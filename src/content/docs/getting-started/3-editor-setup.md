---
title: Editor Setup
---

Lune prioritizes developer experience, providing type definitions and documentation for many editors and tools without any additional downloads. This guide will help you set up your editor environment.

## Luau Language Server

The open source Luau Language Server, also known as [`luau-lsp`](https://github.com/JohnnyMorganz/luau-lsp), is currently the main language server providing editor support for Luau. It supports a wide range of editors.

Once you've installed both the language server and Lune, you can run the following built-in command to generate type definition files and create or update a standardized `.luaurc` configuration file:

```bash title="Terminal"
lune setup
```

This should be all you need to get up and running. You may, however, need to restart your editor for the changes to take effect.
