---
title: Spawning Processes
---

Whenever Lune does not have the API you need as part of its standard libraries, or when you want to
use a program that already exists but interact with it from within Lune, you can use
[`process.exec`](../../api-reference/process.md#exec).

## Example

This example calls out to the native "ping" program found in many operating systems, and parses its
output into something more usable to us.

This may look scary with lots of weird symbols, but, it's just some Lua-style pattern matching to
parse the lines of `"min/avg/max/stddev = W/X/Y/Z ms"` that the ping program gives back to us.

```luau copy
print("Sending 4 pings to google 🌏")

local result = process.exec("ping", {
	"google.com",
	"-c 4",
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
	print("Failed to send ping to google!")
	print(result.stderr)
	process.exit(result.code)
end
```

Note that if the result of the subprocess was non-zero, meaning it errored and `ok` was set to
`false`, we will also propagate the exit code of that subprocess using
[`process.exit`](../../api-reference/process.md#exit). This will ensure that if our subprocess
fails, our script will do the same, and let the user know with a proper exit code.

## Conclusion

This is the last page of the introduction book, for more specific usage and a full overview of all
of the APIs that Lune provides, please check out the API Reference section in the sidebar. Enjoy! 🚀
