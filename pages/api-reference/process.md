# Process

Built-in functions for the current process & child processes

#### Example usage

```lua
local process = require("@lune/process")

-- Getting the arguments passed to the Lune script
for index, arg in process.args do
	print("Process argument #" .. tostring(index) .. ": " .. arg)
end

-- Getting the currently available environment variables
local PORT: string? = process.env.PORT
local HOME: string? = process.env.HOME
for name, value in process.env do
	print("Environment variable " .. name .. " is set to " .. value)
end

-- Getting the current os and processor architecture
print("Running " .. process.os .. " on " .. process.arch .. "!")

-- Spawning a child process
local result = process.spawn("program", {
	"cli argument",
	"other cli argument"
})
if result.ok then
	print(result.stdout)
else
	print(result.stderr)
end
```

## Properties

### os

`OS`

The current operating system being used.

Possible values:

-   `"linux"`
-   `"macos"`
-   `"windows"`

---

### arch

`Arch`

The architecture of the processor currently being used.

Possible values:

-   `"x86_64"`
-   `"aarch64"`

---

### args

`{ string }`

The arguments given when running the Lune script.

---

### cwd

`string`

The current working directory in which the Lune script is running.

---

### env

`{ [string]: string? }`

Current environment variables for this process.

Setting a value on this table will set the corresponding environment variable.

---

## Functions

### exit

Exits the currently running script as soon as possible with the given exit code.

Exit code 0 is treated as a successful exit, any other value is treated as an error.

Setting the exit code using this function will override any otherwise automatic exit code.

#### Parameters

-   `code` The exit code to set

#### Returns

-   never

---

### spawn

Spawns a child process that will run the program `program`, and returns a dictionary that describes
the final status and ouput of the child process.

The second argument, `params`, can be passed as a list of string parameters to give to the program.

The third argument, `options`, can be passed as a dictionary of options to give to the child
process. Refer to the documentation for `SpawnOptions` for specific option keys and their values.

#### Parameters

-   `program` The program to spawn as a child process

-   `params` Additional parameters to pass to the program

-   `options` A dictionary of options for the child process

#### Returns

-   A dictionary representing the result of the child process

---

## Types

### SpawnOptions

A dictionary of options for `process.spawn`, with the following available values:

-   `cwd` - The current working directory for the process
-   `env` - Extra environment variables to give to the process
-   `shell` - Whether to run in a shell or not - set to `true` to run using the default shell, or a
    string to run using a specific shell
-   `stdio` - How to treat output and error streams from the child process - see
    `SpawnOptionsStdioKind` and `SpawnOptionsStdio` for more info
-   `stdin` - Optional standard input to pass to spawned child process

---

### SpawnResult

Result type for child processes in `process.spawn`.

This is a dictionary containing the following values:

-   `ok` - If the child process exited successfully or not, meaning the exit code was zero or not
    set
-   `code` - The exit code set by the child process, or 0 if one was not set
-   `stdout` - The full contents written to stdout by the child process, or an empty string if
    nothing was written
-   `stderr` - The full contents written to stderr by the child process, or an empty string if
    nothing was written

---
