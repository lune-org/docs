---
title: Spawning Processes
---

Whenever Lune doesn't have the API you need as part of its standard libraries, or when you want to use a program that already exists, but interact with it from within Lune, you can spawn a subprocess using [`process.exec`](../../api-reference/process#exec).

## Example

This example calls out to the native "ping" program found on many operating systems, and parses its output into something more usable.

This may look a bit intimidating with all the pattern matching symbols, but it's just parsing the line that says `"min/avg/max/stddev = W/X/Y/Z ms"` from ping's output:

```luau
// ping-example.luau
local process = require("@lune/process")

print("Sending 4 pings to google.com...")

local result = process.exec("ping", {
  "google.com",
  "-c", "4",
})

if result.ok then
	assert(#result.stdout > 0, "Result output was empty")
	local min, avg, max, stddev = string.match(
		result.stdout,
		"min/avg/max/stddev = ([%d%.]+)/([%d%.]+)/([%d%.]+)/([%d%.]+) ms"
	)
	print(string.format("Minimum ping time: %.3fms", tonumber(min)))
	print(string.format("Maximum ping time: %.3fms", tonumber(max)))
	print(string.format("Average ping time: %.3fms", tonumber(avg)))
	print(string.format("Standard deviation: %.3fms", tonumber(stddev)))
else
	print("Failed to send ping to google.com")
	print(result.stderr)
	process.exit(result.code)
end
```

Note that if the subprocess returns a non-zero exit code (meaning it errored and `ok` was set to `false`), we propagate that exit code using [`process.exit`](../../api-reference/process#exit). This ensures that if our subprocess fails, our script fails too, letting the user know something went wrong.

## The Result Table

When you call `process.exec`, you get back a table with these fields:

- `ok` - true if the exit code was 0 (success)
- `code` - the actual exit code
- `stdout` - what the program printed to standard output
- `stderr` - what the program printed to standard error

This should give you everything you need to work with external programs the same way you would when using your terminal - all the text you see outputted when using your terminal, for example, is always part of either `stdout` or `stderr`.

Generally, program output will be in `stdout`, and error messages, warnings, and other miscellaneous information will be in `stderr`.

## Common Use Cases

Beyond the ping example, here are some other ways you might use `process.exec`:

```luau
-- Run git commands
local gitStatus = process.exec("git", { "status", "--short" })

-- Compress files
local zipResult = process.exec("zip", { "-r", "archive.zip", "folder/" })

-- Manipulate images
local result = process.exec("convert", { "input.png", "-resize", "800x600", "output.jpg" })
```

---

<details>
<summary>Extra: Real-time Processing</summary>

As we've seen throughout this chapter, the `process.exec` function only returns a result table, and does not let you interact with the output streams while the process is running. But sometimes, you don't want that simplicity, and you need more granular and real-time processing capabilities for process output.

That's where `process.create` comes in - here's an example for monitoring a log file in real-time and alert when errors occur:

```luau
// log-monitor.luau
local process = require("@lune/process")

-- Start watching a log file
local tail = process.create("tail", { "-f", "/var/log/app.log" })

print("Monitoring log file for errors...")

-- Read new log lines as they appear
while true do
  local line = tail.stdout:read()
  if not line then
    break
  end

  if string.find(line, "ERROR") or string.find(line, "FATAL") then
      print(`🚨 ALERT: {line}`)
      -- Could send notification, write to file, etc.
  end
end
```

</details>

## What's Next?

You can now extend Lune's capabilities by running any program on your system. This opens up endless possibilities - from using git in your scripts to leveraging specialized tools for tasks Lune doesn't handle natively.

But what if you need to run multiple operations at once? Or schedule work to happen later? Let's explore Lune's powerful concurrency features in our last chapter - [The Task Scheduler](./9-task-scheduler).
