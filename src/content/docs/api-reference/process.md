---
title: Process
---

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

-- Executing a command
local result = process.exec("program", {
	"cli argument",
	"other cli argument"
})
if result.ok then
	print(result.stdout)
else
	print(result.stderr)
end

-- Spawning a child process
local child = process.create("program", {
	"cli argument",
	"other cli argument"
})

-- Writing to the child process' stdin
child.stdin:write("Hello from Lune!")

-- Reading from the child process' stdout
local data = child.stdout:read()
print(data)
```

## Properties

### os

`OS`

The current operating system being used.

Possible values:

- `"linux"`
- `"macos"`
- `"windows"`

---

### arch

`Arch`

The architecture of the processor currently being used.

Possible values:

- `"x86_64"`
- `"aarch64"`

---

### endianness

`Endianness`

The endianness of the processor currently being used.

Possible values:

- `"big"`
- `"little"`

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

- `code` The exit code to set

#### Returns

- never

---

### create

Spawns a child process in the background that runs the program `program`,
and immediately returns readers and writers to communicate with it.

In order to execute a command and wait for its output, see `process.exec`.

The second argument, `params`, can be passed as a list of string parameters to give to the program.

The third argument, `options`, can be passed as a dictionary of options to give to the child process.
Refer to the documentation for `SpawnOptions` for specific option keys and their values.

#### Parameters

- `program` The program to Execute as a child process

- `params` Additional parameters to pass to the program

- `options` A dictionary of options for the child process

#### Returns

- A dictionary with the readers and writers to communicate with the child process

---

### exec

Executes a child process that will execute the command `program`, waiting for it to exit.
Upon exit, it returns a dictionary that describes the final status and output of the child process.

In order to spawn a child process in the background, see `process.create`.

The second argument, `params`, can be passed as a list of string parameters to give to the program.

The third argument, `options`, can be passed as a dictionary of options to give to the child process.
Refer to the documentation for `ExecOptions` for specific option keys and their values.

#### Parameters

- `program` The program to Execute as a child process

- `params` Additional parameters to pass to the program

- `options` A dictionary of options for the child process

#### Returns

- A dictionary representing the result of the child process

---

## Types

### ExecStdioKind

Enum determining how to treat a standard input/output stream for `process.exec`.

Can be one of the following values:

- `default` - The default behavior, writing to the final result table only
- `inherit` - Inherit the stream from the parent process, writing to both the result table and the respective stream for the parent process
- `forward` - Forward the stream to the parent process, without writing to the result table, only respective stream for the parent process
- `none` - Do not create any input/output stream

---

### ExecStdioOptions

A dictionary of stdio-specific options for `process.exec`, with the following available values:

- `stdin` - A buffer or string to write to the stdin of the process
- `stdout` - How to treat the stdout stream from the child process - see `ExecStdioKind` for more info
- `stderr` - How to treat the stderr stream from the child process - see `ExecStdioKind` for more info

---

### ExecOptions

A dictionary of options for `process.exec`, with the following available values:

- `cwd` - The current working directory for the process
- `env` - Extra environment variables to give to the process
- `shell` - Whether to run in a shell or not - set to `true` to run using the default shell, or a string to run using a specific shell
- `stdio` - How to treat output and error streams from the child process - see `StdioKind` and `StdioOptions` for more info

---

### CreateOptions

A dictionary of options for `process.create`, with the following available values:

- `cwd` - The current working directory for the process
- `env` - Extra environment variables to give to the process
- `shell` - Whether to run in a shell or not - set to `true` to run using the default shell, or a string to run using a specific shell

---

### ChildProcess

Result type for child processes in `process.create`.

This is a dictionary containing the following values:

- `stdin` - A writer to write to the child process' stdin - see `ChildProcessWriter` for more info
- `stdout` - A reader to read from the child process' stdout - see `ChildProcessReader` for more info
- `stderr` - A reader to read from the child process' stderr - see `ChildProcessReader` for more info
- `kill` - A method that kills the child process
- `status` - A method that yields and returns the exit status of the child process

---

### ExecResult

Result type for child processes in `process.exec`.

This is a dictionary containing the following values:

- `ok` - If the child process exited successfully or not, meaning the exit code was zero or not set
- `code` - The exit code set by the child process, or 0 if one was not set
- `stdout` - The full contents written to stdout by the child process, or an empty string if nothing was written
- `stderr` - The full contents written to stderr by the child process, or an empty string if nothing was written

---

# ChildProcessReader

A reader class to read data from a child process' streams in realtime.

## Functions

### read

Reads a chunk of data up to the specified length, or a default of 1KB at a time.

Returns nil if there is no more data to read.

This function may yield until there is new data to read from reader, if all data
till present has already been read, and the process has not exited.

#### Parameters

- `chunkSize` number?

#### Returns

- The string containing the data read from the reader

---

### readToEnd

Reads all the data currently present in the reader as a string.
This function will yield until the process exits.

#### Returns

- The string containing the data read from the reader

---

# ChildProcessWriter

A writer class to write data to a child process' streams in realtime.

## Functions

### write

Writes a buffer or string of data to the writer.

#### Parameters

- `data` The data to write to the writer

---

### close

Closes the underlying I/O stream for the writer.

---
