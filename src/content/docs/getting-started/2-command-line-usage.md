---
title: Command-Line Usage
---

## Running Scripts

Once you've written a script file, for example `script-name.luau`, you can run it as follows:

```bash title="Terminal"
lune run script-name
```

Lune will look for the file `script-name.luau`**_<sup>[1]</sup>_** in a few locations:

- The current directory
- The folder `lune` in the current directory, if it exists
- The folder `.lune` in the current directory, if it exists
- The folder `lune` in your home directory, if it exists
- The folder `.lune` in your home directory, if it exists

## Listing Scripts

```bash title="Terminal"
lune list
```

This command lists all scripts found in `lune` or `.lune` directories, including any top-level description comments. Lune description comments are written at the top of a file and start with a Lua-style comment arrow (`-->`).

## Advanced Usage

```bash title="Terminal"
lune run -
```

This runs a script passed to Lune using stdin, which is useful for running scripts piped from external sources. Here's an example:

```bash title="Terminal"
echo "print 'Hello, terminal!'" | lune run -
```

---

**_<sup>[1]</sup>_** _Lune also supports files with the `.lua` extension, but using the `.luau` extension is highly recommended. Additionally, if you don't want Lune to look in subdirectories or try to find files with `.lua` / `.luau` extensions at all, you can provide an absolute file path. This will disable all file path parsing and checks, and just run the file directly._
