# Script Arguments

Arguments can be passed to Lune scripts directly from the command line when running them:

```sh copy filename="Bash"
lune run script-name arg1 arg2 "argument three"
```

These arguments will then be available in your script using the
[process](../../api-reference/process.md) built-in library, more specifically in
[`process.args`](../../api-reference/process.md#args):

```lua copy
local process = require("@lune/process")

print(process.args)
--> { "arg1", "arg2", "argument three" }
```

---

Arguments in [`process.args`](../../api-reference/process.md#args) will always be a table that is a
contiguous array, and are guaranteed to not change during runtime. A useful pattern here could be to
check for arguments given, and if there are none, prompt the user for input:

```lua copy
local process = require("@lune/process")
local stdio = require("@lune/stdio")

if #process.args > 3 then
	error("Too many arguments!")
elseif #process.args > 0 then
	print("Got arguments:")
	print(process.args)
else
	print("Got no arguments ☹️")
	local prompted = stdio.prompt("Please enter some text:")
	print("Got prompted text:", prompted)
end
```
