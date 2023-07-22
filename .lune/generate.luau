local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local moonwave = require("./moonwave")
local writeMarkdown = require("./writer")

-- Parse the newly extracted moonwave file
local typedefsFile = fs.readFile("temp/moonwave.json")
local items: { moonwave.Item } = serde.decode("json", typedefsFile)

-- Generate markdown for all of the libraries
local generatedFiles = {}
for _, item in items do
	local file = item.source.path
	local name = string.match(file, "(.+)%.luau")
	assert(name ~= nil, "Failed to remove luau suffix from file name")
	table.insert(generatedFiles, {
		displayName = item.name,
		name = string.lower(name),
		content = writeMarkdown(item),
	})
end

-- Remove any old files, generate new ones
if fs.isDir("pages/api-reference") then
	fs.removeDir("pages/api-reference")
end
fs.writeDir("pages/api-reference")
for _, file in generatedFiles do
	fs.writeFile(`pages/api-reference/{file.name}.md`, file.content)
end

-- Also generate a meta file to make the sidebar look nicer, note that
-- we generate it manually instead of serializing as json because that
-- would not preserve order and the sidebar is order-sensitive
local meta = "{\n"
for index, file in generatedFiles do
	meta ..= `    "{file.name}": "{file.displayName}"`
	if index == #generatedFiles then
		meta ..= "\n}"
	else
		meta ..= ",\n"
	end
end
fs.writeFile(`pages/api-reference/_meta.json`, meta)

-- Finally, call out to prettier to ensure that our
-- generated markdown files are formatted properly
process.spawn("prettier", {
	"--write",
	"pages/api-reference/",
})
