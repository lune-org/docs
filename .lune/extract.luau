local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

-- Make sure we have a repository folder downloaded
assert(fs.isDir("temp/repository"), "Missing downloaded repository folder")

-- Look for where type definitions are stored
local sourceDir
if fs.isDir("temp/repository/docs/typedefs") then
	sourceDir = "temp/repository/docs/typedefs"
elseif fs.isDir("temp/repository/typedefs") then
	sourceDir = "temp/repository/typedefs"
elseif fs.isDir("temp/repository/types") then
	sourceDir = "temp/repository/types"
else
	error("Failed to find typedefs folder in repository")
end

-- Run moonwave to parse typedef files and extract documentation, write to file
local moonwaveResult = process.spawn("moonwave-extractor", { "extract", sourceDir })
assert(moonwaveResult.ok and #moonwaveResult.stderr <= 0, moonwaveResult.stderr)
fs.writeFile("temp/moonwave.json", moonwaveResult.stdout)

-- Let the user know how many typedefs we have extracted
local arr = serde.decode("json", moonwaveResult.stdout)
print("Extracted", #arr, "type definitions")
