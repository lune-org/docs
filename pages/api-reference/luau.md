# Luau

Built-in library for generating luau bytecode & functions.

#### Example usage

```lua
local luau = require("@lune/luau")

local bytecode = luau.compile("print('Hello, World!')")
local callableFn = luau.load(bytecode)

-- Additionally, we can skip the bytecode generation and load a callable function directly from the code itself.
-- local callableFn = luau.load("print('Hello, World!')")

callableFn()
```

## Functions

### compile

Compiles sourcecode into Luau bytecode

An error will be thrown if the sourcecode given isn't valid Luau code.

#### Example usage

```lua
local luau = require("@lune/luau")

local bytecode = luau.compile("print('Hello, World!')", {
	optimizationLevel: 1,
	coverageLevel: 0,
	debugLevel: 1,
})
```

#### Parameters

-   `source` The string that'll be compiled into bytecode

-   `CompileOptions` The luau compiler options used when compiling the source string

#### Returns

-   luau bytecode

---

### load

Generates a function from either bytecode or sourcecode

An error will be thrown if the sourcecode given isn't valid luau code.

#### Example usage

```lua
local luau = require("@lune/luau")

local bytecode = luau.compile("print('Hello, World!')")
local callableFn = luau.load(bytecode, {
	debugName = "'Hello, World'"
})

callableFn()
```

#### Parameters

-   `source` Either bytecode or sourcecode

-   `loadOptions` The load options used when creating a callbable function

#### Returns

-   luau function

---

## Types

### CompileOptions

The Luau compiler options used in generating luau bytecode

This is a dictionary that may contain one or more of the following values:

-   `optimizationLevel` - Sets the compiler option "optimizationLevel". Defaults to `1`
-   `coverageLevel` - Sets the compiler option "coverageLevel". Defaults to `0`
-   `debugLevel` - Sets the compiler option "debugLevel". Defaults to `1`

Documentation regarding what these values represent can be found here;

-   https://github.com/Roblox/luau/blob/bd229816c0a82a8590395416c81c333087f541fd/Compiler/include/luacode.h#L13

---

### LoadOptions

The Luau load options are used for generating a lua function from either bytecode or sourcecode

This is a dictionary that may contain one or more of the following values:

-   `debugName` - The debug name of the closure. Defaults to `string ["..."]`

---
