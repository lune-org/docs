---
title: The Task Scheduler
---

Lune is built around a task scheduler, which can let you run things at fixed intervals, ensure some work happens after everything else is already done, and more.

The task scheduler is the backbone of Lune, and lets you handle structured concurrency. It is implemented using lightweight Lua threads / coroutines, and has **strong ordering guarantees**.

## Ordering

The main purpose of the task scheduler is to ensure consistent ordering, and to let you prioritize work on three different levels by using the `task` standard library:

1. **Immediate**: Tasks that should run immediately can be spawned using `task.spawn`.
2. **Deferred**: Tasks that should run after all immediate tasks have finished can be spawned using `task.defer`.
3. **Delayed**: Tasks that should run after a certain amount of time has passed can be spawned using `task.delay`.

<details>
<summary>Advanced: Runtime-Controlled Threads & Prioritization</summary>

These are user-facing concepts, but perhaps more interesting, is that Lune _**prioritizes Lua threads**_ over runtime-spawned tasks, such as those for incoming requests in `net.serve`.

This means that, in real world scenarios such as handling incoming requests in an HTTP server, the scheduler will ensure that your existing tasks are not starved of resources, and are always prioritized over handling new requests, for maximum throughput & lowest possible latency.

</details>

## Example Usage

### Spawning Tasks & Waiting

This example script will run several tasks concurrently, in lightweight Lua threads, also known as coroutines:

```luau
// basic-tasks.luau
local task = require("@lune/task")

print("Hello, scheduler!")

task.spawn(function()
	print("Spawned a task that will run instantly but not block")
	task.wait(2)
	print("The instant task resumed again after 2 seconds")
end)

print("Spawning a delayed task that will run after 5 seconds")

task.delay(5, function()
	print("Waking up from my deep slumber...")
	task.wait(1)
	print("Hello again!")
	task.wait(1)
	print("Goodbye again! 🌙")
end)
```

### Deferring Work

This example script runs a bit of work after all other threads have finished their work or are yielding waiting for some other result:

```luau
// deferred-tasks.luau
local task = require("@lune/task")

task.defer(function()
	print("All the scheduled work has finished, let's do some more!")
	local a = 0
	for _ = 1, 100000 do
		local b = a + 1
	end
	print("Phew, that was tough.")
end)

print("Working...")
local s = ""
for _ = 1, 5000 do
	s ..= ""
end
print("Done!")
```

### Advanced Usage & Async

Spawning tasks like this can be very useful together with asynchronous APIs from other standard libraries, such as [`net.request`](../../api-reference/net.md#request):

```luau
// async-tasks.luau
local net = require("@lune/net")
local task = require("@lune/task")

local completed = false
task.spawn(function()
	while not completed do
		print("Waiting for response...")
		task.wait() -- Wait the minimum amount possible
	end
	print("No longer waiting!")
end)

print("Sending request")
net.request("https://google.com")
print("Got response")

completed = true
```

<details>
<summary>Bonus</summary>

### Barebones Signal Implementation

Using the task library, it becomes trivial to implement signal objects that take callbacks to run when a signal is fired, and that can handle both synchronous and yielding (async) callbacks without additional complexity:

```luau
// signals.luau
local task = require("@lune/task")

local function newSignal()
	local callbacks = {}

	local function connect(callback: (...any) -> ())
		table.insert(callbacks, callback)
	end

	local function fire(...: any)
		for _, callback in callbacks do
			task.spawn(callback, ...)
		end
	end

	return connect, fire
end

local connectToThing, fireThing = newSignal()

connectToThing(function(value)
	print("Callback #1 got value:", value)
	task.wait(1)
	print("Callback #1 still has value:", value)
end)

connectToThing(function(value)
	print("Callback #2 got value:", value)
	task.wait(0.5)
	print("Callback #2 still has value:", value)
end)

print("Before firing")
fireThing(123)
print("After firing")

--> Before firing
--> Callback #1 got value: 123
--> Callback #2 got value: 123
--> After firing
--> ...
--> Callback #2 still has value: 123
--> ...
--> Callback #1 still has value: 123
```

</details>

## Conclusion

Congratulations! You've completed The Lune Book and now have all the tools you need to build powerful scripts with Lune.

You've learned how to work with files, make network requests, handle user input, organize code into modules, spawn external processes, and how to wrangle the task scheduler. More importantly, you've seen how these pieces work together to create scripts that are both simple to write and capable of handling complex real-world problems.

The API reference in the sidebar contains detailed documentation for all of Lune's capabilities, and the community is always ready to help if you get stuck.

Now go build! 🚀
