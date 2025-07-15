local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")

-- Make sure we have a repository folder downloaded
assert(fs.isDir("temp/repository"), "Missing downloaded repository folder")

-- Run moonwave to parse typedef files and extract documentation, write to file
local moonwaveResult = process.exec("moonwave-extractor", { "extract", "temp/repository/crates" })
assert(moonwaveResult.ok and #moonwaveResult.stderr <= 0, moonwaveResult.stderr)
fs.writeFile("temp/moonwave.json", moonwaveResult.stdout)

-- Let the user know how many typedefs we have extracted
local arr = serde.decode("json", moonwaveResult.stdout)
print("Extracted", #arr, "type definitions")
