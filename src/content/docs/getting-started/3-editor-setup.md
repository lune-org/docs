---
title: Editor Setup
---

Lune prioritizes developer experience, and as such type definitions and documentation are provided
for several editors and tools without any additional downloads. This guide will help you get set up
with your editor environment.

## Luau Language Server

The open source Luau Language Server, also known as [`luau-lsp`](https://github.com/JohnnyMorganz/luau-lsp),
is currently the main language server providing editor support for Luau. It supports a wide range of editors.

Once you have installed the language server, as well as Lune, running the following built-in command will
generate type definition files, and add / modify a standardized `.luaurc` configuration file pointing to them:

```bash title="Terminal"
lune setup
```
