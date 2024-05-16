local datetime = require("@lune/datetime")
local fs = require("@lune/fs")
local luau = require("@lune/luau")
local net = require("@lune/net")
local process = require("@lune/process")
local regex = require("@lune/regex")
local roblox = require("@lune/roblox")
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")
local task = require("@lune/task")

local processArgs = table.clone(process.args)
local filePath: string = table.remove(processArgs, 1)
	or error("usage: lune run sandbox [SCRIPT_PATH] -- [ARGS]")

local DEFAULT_PRINT = print
local SANDBOXED_ENV = {
	debugName = filePath,
	environment = {
		require = nil,
		getfenv = nil,
		setfenv = nil,
		print = nil,
		warn = nil,
	},
}

local PROMPT_MSG_TMPL = `allow {SANDBOXED_ENV.debugName} to access %s?`
local DENIED_ERR_TMPL = `{SANDBOXED_ENV.debugName} tried to access disallowed library %s!`

local function discoverAndReadScript(filePath: string): string
	local scriptContents: string

	if fs.isFile(filePath) then
		scriptContents = fs.readFile(filePath)
		return scriptContents
	end

	if fs.isDir(filePath) then
		if fs.isFile(filePath .. "/init.luau") then
			scriptContents = fs.readFile(filePath .. "/init.luau")
		end

		if fs.isFile(filePath .. "/init.lua") then
			scriptContents = fs.readFile(filePath .. "init.lua")
		end
	end

	if scriptContents == nil then
		for _, ext in { ".luau", ".lua" } do
			local filePathExt = filePath .. ext
			if fs.isFile(filePathExt) then
				scriptContents = fs.readFile(filePathExt)
			end
		end

		if scriptContents == nil then
			error(`No such file or directory \`{filePath}\``)
		end
	end

	return scriptContents
end

local function sandboxGetfenv(): {}
	if table.isfrozen(SANDBOXED_ENV) then
		return SANDBOXED_ENV.environment
	end

	return {}
end

local function sandboxSetfenv(env: {}): never
	error("cannot call setfenv from sandbox")
end

local function sandboxPrint(...: any)
	DEFAULT_PRINT(`---- Output from {SANDBOXED_ENV.debugName} ----`)
	DEFAULT_PRINT(tostring(...))
	DEFAULT_PRINT(`---------------------------------------`)
end

local function constructProtectedMt<T>(library: T)
	return {
		__index = library,
		__tostring = function()
			return stdio.format(library)
		end,
	}
end

local SANDBOXED_LUNE_STD_LIB = {
	["@lune/fs"] = setmetatable({}, constructProtectedMt(fs)),
	["@lune/luau"] = setmetatable({}, constructProtectedMt(luau)),
	["@lune/process"] = setmetatable({}, constructProtectedMt(process)),
	["@lune/stdio"] = setmetatable({
		write = sandboxPrint,
		ewrite = sandboxPrint,
	}, constructProtectedMt(stdio)),
	["@lune/net"] = setmetatable({}, constructProtectedMt(net)),
	["@lune/roblox"] = setmetatable({
		getAuthCookie = function(...)
			local allowAuthCookie: boolean = stdio.prompt(
				"confirm",
				`allow {SANDBOXED_ENV.debugName} to access your .ROBLOSECURITY token?`
			)

			if allowAuthCookie then
				local getAuthCookie = require("@lune/roblox").getAuthCookie
				return getAuthCookie(...)
			end

			error(
				`{SANDBOXED_ENV.debugName} attempted to access .ROBLOSECURITY token even when denied`
			)
		end,
	}, constructProtectedMt(roblox)),
	["@lune/serde"] = serde,
	["@lune/task"] = task,
	["@lune/regex"] = regex,
	["@lune/datetime"] = datetime,
}

local function sandboxedRequire(path: string)
	local module = SANDBOXED_LUNE_STD_LIB[path]

	if module then
		local allowed: boolean = stdio.prompt("confirm", string.format(PROMPT_MSG_TMPL, path))

		if allowed then
			return module
		end

		error(string.format(DENIED_ERR_TMPL, path))
	else
		local contents = discoverAndReadScript(path)

		local evalChunk = luau.load(contents, SANDBOXED_ENV)
		return evalChunk()
	end
end

SANDBOXED_ENV.environment.require = sandboxedRequire
SANDBOXED_ENV.environment.getfenv = sandboxGetfenv
SANDBOXED_ENV.environment.setfenv = sandboxSetfenv
SANDBOXED_ENV.environment.print = sandboxPrint
SANDBOXED_ENV.environment.warn = sandboxPrint
luau.load(discoverAndReadScript(filePath), table.freeze(SANDBOXED_ENV))()
