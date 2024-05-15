local fs = require("@lune/fs")
local luau = require("@lune/luau")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local processArgs = table.clone(process.args)
local filePath: string = table.remove(processArgs, 1)

local DEFAULT_REQUIRE = require
local DEFAULT_PRINT = print
local SANDBOXED_ENV = {
	debugName = filePath,
	environment = {
		require = nil,
	},
}

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

local function sandboxPrint(...: any)
	DEFAULT_PRINT(`---- Output from {SANDBOXED_ENV.debugName} ----`)
	DEFAULT_PRINT(...)
	DEFAULT_PRINT(`---------------------------------------`)
end

local function sandboxedRequire<T>(path: string): T
	if path:find("@lune") then
		local module = path:split("/")[2]

		if module == "net" or module == "fs" or module == "process" or module == "roblox" then
			local allow: boolean =
				stdio.prompt("confirm", `allow {SANDBOXED_ENV.debugName} to access {module}?`)

			if allow then
				local moduleRequire = DEFAULT_REQUIRE(path)

				return setmetatable({}, {
					__index = function(_, key)
						local value = moduleRequire[key]

						if typeof(value) == "function" then
							if module == "roblox" and key == "getAuthCookie" then
								local allowAuthCookie: boolean = stdio.prompt(
									"confirm",
									`allow {SANDBOXED_ENV.debugName} to access to .ROBLOSECURITY token?`
								)

								if allowAuthCookie then
									return value
								end
							end

							return function(...)
								warn(`{SANDBOXED_ENV.debugName} invoked {key} with args {...}`)
								return value(...)
							end
						end

						if module == "process" and key == "args" then
							return processArgs
						end

						return value
					end,

					__tostring = function()
						return stdio.format(moduleRequire)
					end,
				})
			end

			error(`{SANDBOXED_ENV.debugName} tried to access disallowed library {module}`)
		end

		local otherModule = DEFAULT_REQUIRE(path)

		if module == "stdio" then
			return setmetatable({
				write = sandboxPrint,
				ewrite = sandboxPrint,
			}, {
				__index = otherModule,
			})
		end

		return otherModule
	else
		local contents = discoverAndReadScript(path)

		local evalChunk: () -> T = luau.load(contents, SANDBOXED_ENV)
		return evalChunk()
	end
end

SANDBOXED_ENV.environment.require = sandboxedRequire
SANDBOXED_ENV.environment.print = sandboxPrint
SANDBOXED_ENV.environment.warn = sandboxPrint
luau.load(discoverAndReadScript(filePath), table.freeze(SANDBOXED_ENV))()
