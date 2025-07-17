---
title: "Example Scripts"
---

These are a few short examples of things you can do using the `roblox` standard library.

## Make all parts anchored in a place file

```luau
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

-- Read the place file called myPlaceFile.rbxl into a DataModel variable called "game"
-- This works exactly the same as in Roblox, except "game" does not exist by default.
-- To access "game" you have to load it from a file!
local file = fs.readFile("myPlaceFile.rbxl")
local game = roblox.deserializePlace(file)
local workspace = game:GetService("Workspace")

-- Make all of the parts in the workspace anchored
for _, descendant in workspace:GetDescendants() do
	if descendant:IsA("BasePart") then
		descendant.Anchored = true
	end
end

-- Save the DataModel (game) back to the file that we read it from
file = roblox.serializePlace(game)
fs.writeFile("myPlaceFile.rbxl", file)
```

---

## Save instances in a place as individual model files

```luau
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

-- Here we load a file just like in the first example
local file = fs.readFile("myPlaceFile.rbxl")
local game = roblox.deserializePlace(file)
local workspace = game:GetService("Workspace")

-- Make sure a directory exists to save our models in
fs.writeDir("models")

-- Then we save all of our instances in Workspace as model files, in our new directory
-- Note that a model file can actually contain several instances at once, so we pass a table here
for _, child in workspace:GetChildren() do
	file = roblox.serializeModel({ child })
	fs.writeFile("models/" .. child.Name, file)
end
```

---

## Make a new place from scratch

```luau
local fs = require("@lune/fs")
local roblox = require("@lune/roblox")
local Instance = roblox.Instance

-- You can even create a new DataModel using Instance.new, which is not normally possible in Roblox
-- This is normal - most instances that are not normally accessible in Roblox can be manipulated using Lune!
local game = Instance.new("DataModel")
local workspace = game:GetService("Workspace")

-- Here we just make a bunch of models with parts in them for demonstration purposes
for i = 1, 50 do
	local model = Instance.new("Model")
	model.Name = "Model #" .. tostring(i)
	model.Parent = workspace
	for j = 1, 4 do
		local part = Instance.new("Part")
		part.Name = "Part #" .. tostring(j)
		part.Parent = model
	end
end

-- As always, we have to save the DataModel (game) to a file when we're done
local file = roblox.serializePlace(game)
fs.writeFile("myPlaceWithLotsOfModels.rbxl", file)
```
