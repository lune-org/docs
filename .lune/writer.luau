local moonwave = require("./moonwave")

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
			write("`" .. typ .. "`")
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

local function writeMarkdown(item: moonwave.Item)
	write(`# {item.name}\n\n`)
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
		write(`## Functions\n\n`)
		for _, fn in item.functions do
			write(`### {fn.name}\n\n`)
			writeDesc(fn.desc)
			writeParams(fn.params)
			writeReturns(fn.returns)
			write(`---\n\n`)
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
