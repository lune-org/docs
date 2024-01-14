# Command-Line Usage

## Running Scripts

When you've written a script file, for example `script-name.luau`, you can run it as such:

```sh copy
lune run script-name
```

This will look for the file `script-name.luau`**_<sup>[1]</sup>_** in a few locations:

-   The current directory
-   The folder `lune` in the current directory, if it exists
-   The folder `.lune` in the current directory, if it exists
-   The folder `lune` in the _home_ directory, if it exists
-   The folder `.lune` in the _home_ directory, if it exists

## Listing Scripts

```sh copy
lune list
```

Lists all scripts found in `lune` or `.lune` directories, including any top-level description
comments. <br /> Lune description comments are always written at the top of a file and start with a
lua-style comment arrow (`-->`).

## Advanced Usage

```sh copy
lune run -
```

Runs a script passed to Lune using stdin. Useful for running scripts piped to Lune from external
sources. Example:

```sh copy
echo "print 'Hello, terminal!'" | lune run -
```

---

**_<sup>[1]</sup>_** _Lune also supports files with the `.lua` extension but using the `.luau`
extension is highly recommended. Additionally, if you don't want Lune to look in sub-directories or
try to find files with `.lua` / `.luau` extensions at all, you can provide an absolute file path.
This will disable all file path parsing and checks, and just run the file directly._
