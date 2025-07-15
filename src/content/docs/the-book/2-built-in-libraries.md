---
title: The Standard Library
---

Lune contains a comprehensive standard library. It includes, but
is not limited to, these libraries and their common use cases:

- The [`fs`](../../api-reference/fs.md) library for manipulating files
- The [`net`](../../api-reference/net.md) library for making HTTP requests
- The [`process`](../../api-reference/process.md) library for executing external programs and processes

This is just a small subset of what is available in Lune, but for now, what is important is that
these libraries must be imported using a special kind of `require` statement:

```luau copy
local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")
```

As you can see above, unlike Luau's standard libraries such as
[`math`](https://luau-lang.org/library#math-library),
[`table`](https://luau-lang.org/library#table-library),
[`string`](https://luau-lang.org/library#string-library), and others, Lune's built-in libraries
are not available as global variables, and importing them before using them is, _required_.

The next few sections will contain examples of how to run scripts, more specific usage of Lune's
built-in libraries, and what they are most commonly used for.
