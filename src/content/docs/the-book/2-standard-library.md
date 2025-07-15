---
title: The Standard Library
---

Lune has a comprehensive standard library that gives your scripts powerful capabilities. These libraries let you do everything from reading files, to making web requests, to running other programs.

Here are some of the most commonly used libraries:

- [`fs`](../../api-reference/fs) - Work with files and directories
- [`net`](../../api-reference/net) - Make HTTP requests and create servers
- [`process`](../../api-reference/process) - Run external programs and access system information
- [`stdio`](../../api-reference/stdio) - Get input from users and display output
- [`task`](../../api-reference/task) - Schedule and manage concurrent tasks

## Importing Libraries

Unlike Luau's built-in globals like [`math`](https://luau-lang.org/library#math-library) or [`table`](https://luau-lang.org/library#table-library), Lune's libraries need to be imported before you can use them. You do this with a special `require` statement:

```luau
local fs = require("@lune/fs")
local net = require("@lune/net")
local process = require("@lune/process")
```

The `@lune/` prefix tells Lune that you want to use one of its built-in libraries rather than looking for a file in your project.

Throughout the rest of this book, we'll explore these libraries in detail and see how they work together to make Lune scripts powerful and flexible.
