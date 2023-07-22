# Lune

A standalone [Luau](https://luau-lang.org) script runtime.

Write and run scripts, similar to runtimes for other languages such as [Node](https://nodejs.org) /
[Deno](https://deno.land), or [Luvit](https://luvit.io) for vanilla Lua.

Lune provides fully asynchronous APIs wherever possible, and is built in Rust 🦀 for optimal safety
and correctness.

## Features

-   🌙 A strictly minimal but powerful interface that is easy to read and remember, just like Luau
    itself
-   🧰 Fully featured APIs for the filesystem, networking, stdio, all included in the small (~3mb)
    executable
-   📚 World-class documentation, on the web _or_ directly in your editor, no network connection
    necessary
-   🏡 A familiar scripting environment for Roblox developers, with an included 1-to-1 task
    scheduler port
-   ✏️ Optional built-in library for manipulating Roblox place & model files, and their instances

## Non-goals

-   Making scripts short and terse - proper autocomplete / intellisense make scripting using Lune
    just as quick, and readability is important
-   Running full Roblox game scripts outside of Roblox - there is some compatibility, but Lune is
    meant for different purposes

## Where do I start?

Head over to the [Installation](./getting-started/1-installation.md) page to get started using Lune!
