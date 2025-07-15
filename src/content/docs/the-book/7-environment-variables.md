---
title: Environment Variables
---

Environment variables, just like script arguments, are available using the
[process](../../api-reference/process.md) built-in library, more specifically in
[`process.env`](../../api-reference/process.md#env):

```luau
local process = require("@lune/process")

assert(process.env.PATH ~= nil, "Missing PATH")
assert(process.env.PWD ~= nil, "Missing PWD")

process.env.MY_VAR = "Hello, env!"

print(process.env.MY_VAR)
--> Hello, env!
```

Unlike [`process.args`](../../api-reference/process.md#args), environment variables can be read from
and written to freely, and can be done at any point during runtime.

You can also iterate over all of the known environment variables using Luau's generalized iteration.
Here is an example snippet that prints a checkmark if an environment variable has some contents and
is not empty, and a red cross otherwise:

```luau
local process = require("@lune/process")

for key, value in process.env do
	local box = if value ~= "" then "✅" else "❌"
	print(string.format("[%s] %s", box, key))
end
```

Note that using `pairs` or `ipairs` will _not_ work here, only generalized iteration.
