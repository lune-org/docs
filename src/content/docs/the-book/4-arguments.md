---
title: Arguments
---

When you run a Lune script, you can pass information to it directly from the command line. These are called arguments, and they're incredibly useful for making your scripts flexible and reusable.

## Passing Arguments

Passing arguments when running a script is dead simple. Here's how:

```bash title="Terminal"
lune run script-name arg1 arg2 "argument three"
```

## Using Arguments

Your script can then access these arguments through the `process` standard library:

```luau
local process = require("@lune/process")

print(process.args)
--> { "arg1", "arg2", "argument three" }
```

The arguments will always be an array (table) of strings, in the same order you provided them.

## A Practical Example

Let's create a script that greets someone by name:

```luau
// greet.luau
local process = require("@lune/process")

if #process.args == 0 then
  print("Usage: lune run greet <name>")
  print("Example: lune run greet Alice")
else
	local name = process.args[1]
	print(`Hello, {name}! Welcome to Lune.`)
end
```

Now you can run it with different names:

```bash title="Terminal"
lune run greet Alice
--> Hello, Alice! Welcome to Lune.

lune run greet "John Doe"
--> Hello, John Doe! Welcome to Lune.
```

## Combining Arguments with User Input

Here's a clever pattern - use arguments when provided, but fall back to prompting the user if they're missing:

```luau
// smart-greet.luau
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local name
if #process.args > 0 then
	name = process.args[1]
else
	name = stdio.prompt("text", "What's your name?")
end

print(`Hello, {name}!`)
```

This script works both ways - with arguments or interactively!

## What's Next?

Now that you can handle user input and arguments, let's explore one of Lune's most powerful features - the standard library for networking. Head over to [Networking](./5-networking) to learn more.
