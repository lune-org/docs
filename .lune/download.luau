local MAIN_REPOSITORY_URL = "https://github.com/lune-org/lune"

local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")

-- Find the url we should download from, either from a
-- given commit or by looking up the latest release tag
local name
local commit = process.args[1]
if commit ~= nil and #commit > 0 then
	name = commit
else
	print("Looking for the latest tag")
	local tagsResult = process.spawn("git", {
		"ls-remote",
		"--tags",
		"--sort=-v:refname",
		MAIN_REPOSITORY_URL,
	})
	assert(tagsResult.ok, tagsResult.stderr)

	local lines = string.split(tagsResult.stdout, "\n")
	assert(#lines > 0, "No tags were found for the repository")

	local latestTag = string.match(lines[1], "%s*refs/tags/(%S+)%s*$")
	assert(latestTag ~= nil, "Failed to find latest tag for repository")
	name = latestTag
end

-- Create the temp dir if we don't have one
if not fs.isDir("temp") then
	fs.writeDir("temp")
end

-- Remove any previously downloaded repository folder
if fs.isDir("temp/repository") then
	fs.removeDir("temp/repository")
end

-- Download the repository using the given tag or commit, unzip it, remove zip
print(`Downloading '{name}'`)
local downloaded = net.request(`{MAIN_REPOSITORY_URL}/archive/{name}.zip`)
assert(downloaded.ok, downloaded.statusMessage)

fs.writeFile("temp/download.zip", downloaded.body)

local unzipResult = process.spawn("unzip", {
	"temp/download.zip",
	"-d",
	"temp/download",
})
assert(unzipResult.ok, unzipResult.stderr)

fs.removeFile("temp/download.zip")

-- Move the repository folder we just downloaded, which we do not know
-- the name of, but we know there is only one, into a known location
local repoFolderName = fs.readDir("temp/download")[1]
fs.move("temp/download/" .. repoFolderName, "temp/repository")
fs.removeDir("temp/download")
