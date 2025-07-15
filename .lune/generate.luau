local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local moonwave = require("./moonwave")
local writeMarkdown = require("./writer")

-- Parse the newly extracted moonwave file
local typedefsFile = fs.readFile("temp/moonwave.json")
local items: { moonwave.Item } = serde.decode("json", typedefsFile)

-- Sort all of the extracted files & items, making sure that
-- the item that matches the library name always comes first,
-- which will prevent for example ChildProcessWriter from
-- becoming the title for the Process standard library
local parsedFiles = {} :: { [number]: {
	path: string,
	name: string,
	item: moonwave.Item,
} }
for _, item in items do
	local rawPath = item.source.path

	local path = string.match(rawPath, "lune%-std%-(.+)/types%.d%.luau")
	assert(path ~= nil, "Failed to match standard library path")

	table.insert(parsedFiles, {
		path = string.lower(path),
		name = item.name,
		item = item,
	})
end
table.sort(parsedFiles, function(a, b)
	local aIsExact = a.path == string.lower(a.name)
	local bIsExact = b.path == string.lower(b.name)
	if aIsExact ~= bIsExact then
		return aIsExact
	end
	return a.path < b.path
end)

-- Generate all of the markdown
local generatedFiles = {} :: { [number]: {
	path: string,
	name: string,
	content: string,
} }
for _, parsed in parsedFiles do
	-- If we have an existing entry, such as when we have multiple
	-- classes within the same library (Regex, RegexCaptures, ...)
	-- we want to append to the existing entry instead of creating
	local existing = nil
	for _, info in generatedFiles do
		if info.path == string.lower(parsed.path) then
			existing = info
			break
		end
	end

	if existing then
		existing.content ..= writeMarkdown(parsed.item, false)
	else
		local content = `---\ntitle: {parsed.item.name}\n---\n\n`
		content ..= writeMarkdown(parsed.item, true)
		table.insert(generatedFiles, {
			path = string.lower(parsed.path),
			name = parsed.name,
			content = content,
		})
	end
end

-- Remove any old files, generate new ones
if fs.isDir("src/content/docs/api-reference") then
	fs.removeDir("src/content/docs/api-reference")
end
fs.writeDir("src/content/docs/api-reference")
for _, file in generatedFiles do
	fs.writeFile(`src/content/docs/api-reference/{file.path}.md`, file.content)
end

-- Finally, call out to prettier to ensure that our
-- generated markdown files are formatted properly
process.exec("bun", {
	"prettier",
	"--write",
	"src/content/docs/api-reference/",
})
