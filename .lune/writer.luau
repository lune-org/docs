local moonwave = require("./moonwave")

local function trim(s: string): string
	local result = s
	result = string.gsub(result, "^%s+", "")
	result = string.gsub(result, "%s+$", "")
	return result
end

local buffer = {}
local function write(text: string)
	table.insert(buffer, text)
end

local function writeDesc(desc: string)
	desc = string.gsub(desc, "###", "####")
	write(`{desc}\n\n`)
end

local function writeTypeAndDesc(typ: string, desc: string, inline: boolean)
	if #typ > 0 and #desc <= 0 then
		-- HACK: Got empty desc but we have a type, this is a doc comment not a type
		if inline then
			write(" ")
		end
		write(typ)
		if not inline then
			write("\n\n")
		end
	elseif #desc > 0 then
		if #typ > 0 then
			if inline then
				write(" ")
			end
			write("`" .. trim(typ) .. "`")
			if not inline then
				write("\n\n")
			end
		end
		if inline then
			write(" ")
		end
		write(desc)
		if not inline then
			write("\n\n")
		end
	end
end

local function writeParams(params: { moonwave.FunctionParam })
	if #params > 0 then
		write(`#### Parameters\n\n`)
		for _, param in params do
			write(`- \`{param.name}\``)
			writeTypeAndDesc(param.lua_type, param.desc, true)
			write("\n\n")
		end
	end
end

local function writeReturns(returns: { moonwave.FunctionReturn })
	if #returns > 0 then
		write(`#### Returns\n\n`)
		for _, ret in returns do
			write(`- `)
			writeTypeAndDesc(ret.lua_type, ret.desc, true)
			write("\n\n")
		end
	end
end

local function writeFunctions(fns: { moonwave.Function })
	for _, fn in fns do
		write(`### {fn.name}\n\n`)
		writeDesc(fn.desc)
		writeParams(fn.params)
		writeReturns(fn.returns)
		write(`---\n\n`)
	end
end

local function writeMarkdown(item: moonwave.Item, isFirstWrite: boolean)
	if not isFirstWrite then
		-- Astro will automatically insert a H1 with the title in the frontmatter,
		-- so if we had inserted one here, we would have duplicate H1s
		write(`# {item.name}\n\n`)
	end

	writeDesc(item.desc)

	if #item.properties > 0 then
		write(`## Properties\n\n`)
		for _, prop in item.properties do
			write(`### {prop.name}\n\n`)
			writeTypeAndDesc(prop.lua_type, prop.desc, false)
			write("\n\n")
			write(`---\n\n`)
		end
	end

	if #item.functions > 0 then
		local foundStatic = {}
		local foundConstructors = {}
		local foundMethods = {}
		for _, fn in item.functions do
			if fn.tags ~= nil and table.find(fn.tags, "Constructor") ~= nil then
				table.insert(foundConstructors, fn)
			elseif fn.tags ~= nil and table.find(fn.tags, "Method") ~= nil then
				table.insert(foundMethods, fn)
			else
				table.insert(foundStatic, fn)
			end
		end
		if #foundStatic > 0 then
			write(`## Functions\n\n`)
			writeFunctions(foundStatic)
		end
		if #foundConstructors > 0 then
			write(`## Constructors\n\n`)
			writeFunctions(foundConstructors)
		end
		if #foundMethods > 0 then
			write(`## Methods\n\n`)
			writeFunctions(foundMethods)
		end
	end

	if #item.types > 0 then
		write(`## Types\n\n`)
		for _, typ in item.types do
			write(`### {typ.name}\n\n`)
			writeDesc(typ.desc)
			write(`---\n\n`)
		end
	end

	local result = table.concat(buffer, "")
	table.clear(buffer)
	return result
end

return writeMarkdown
