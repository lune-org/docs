---
title: Task
---

Built-in task scheduler & thread spawning

#### Example usage

```lua
local task = require("@lune/task")

-- Waiting for a certain amount of time
task.wait(1)
print("Waited for one second")

-- Running a task after a given amount of time
task.delay(2, function()
	print("Ran after two seconds")
end)

-- Spawning a new task that runs concurrently
task.spawn(function()
	print("Running instantly")
	task.wait(1)
	print("One second passed inside the task")
end)

print("Running after task.spawn yields")
```

## Functions

### cancel

Stops a currently scheduled thread from resuming.

#### Parameters

- `thread` The thread to cancel

---

### defer

Defers a thread or function to run at the end of the current task queue.

#### Parameters

- `functionOrThread` The function or thread to defer

- `...` T...

#### Returns

- The thread that will be deferred

---

### delay

Delays a thread or function to run after `duration` seconds.

#### Parameters

- `duration` number

- `functionOrThread` The function or thread to delay

- `...` T...

#### Returns

- The thread that will be delayed

---

### spawn

Instantly runs a thread or function.

If the spawned task yields, the thread that spawned the task
will resume, letting the spawned task run in the background.

#### Parameters

- `functionOrThread` The function or thread to spawn

- `...` T...

#### Returns

- The thread that was spawned

---

### wait

Waits for _at least_ the given amount of time.

The minimum wait time possible when using `task.wait` is limited by the underlying OS sleep implementation.
For most systems this means `task.wait` is accurate down to about 5 milliseconds or less.

#### Parameters

- `duration` The amount of time to wait

#### Returns

- The exact amount of time waited

---
