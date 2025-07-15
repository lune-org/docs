---
title: FS
---

Built-in library for filesystem access

#### Example usage

```lua
local fs = require("@lune/fs")

-- Reading a file
local myTextFile: string = fs.readFile("myFileName.txt")

-- Reading entries (files & dirs) in a directory
for _, entryName in fs.readDir("myDirName") do
	if fs.isFile("myDirName/" .. entryName) then
		print("Found file " .. entryName)
	elseif fs.isDir("myDirName/" .. entryName) then
		print("Found subdirectory " .. entryName)
	end
end
```

## Functions

### readFile

Reads a file at `path`.

An error will be thrown in the following situations:

- `path` does not point to an existing file.
- The current process lacks permissions to read the file.
- Some other I/O error occurred.

#### Parameters

- `path` The path to the file to read

#### Returns

- The contents of the file

---

### readDir

Reads entries in a directory at `path`.

An error will be thrown in the following situations:

- `path` does not point to an existing directory.
- The current process lacks permissions to read the contents of the directory.
- Some other I/O error occurred.

#### Parameters

- `path` The directory path to search in

#### Returns

- A list of files & directories found

---

### writeFile

Writes to a file at `path`.

An error will be thrown in the following situations:

- The file's parent directory does not exist.
- The current process lacks permissions to write to the file.
- Some other I/O error occurred.

#### Parameters

- `path` The path of the file

- `contents` The contents of the file

---

### writeDir

Creates a directory and its parent directories if they are missing.

An error will be thrown in the following situations:

- `path` already points to an existing file or directory.
- The current process lacks permissions to create the directory or its missing parents.
- Some other I/O error occurred.

#### Parameters

- `path` The directory to create

---

### removeFile

Removes a file.

An error will be thrown in the following situations:

- `path` does not point to an existing file.
- The current process lacks permissions to remove the file.
- Some other I/O error occurred.

#### Parameters

- `path` The file to remove

---

### removeDir

Removes a directory and all of its contents.

An error will be thrown in the following situations:

- `path` is not an existing and empty directory.
- The current process lacks permissions to remove the directory.
- Some other I/O error occurred.

#### Parameters

- `path` The directory to remove

---

### metadata

Gets metadata for the given path.

An error will be thrown in the following situations:

- The current process lacks permissions to read at `path`.
- Some other I/O error occurred.

#### Parameters

- `path` The path to get metadata for

#### Returns

- Metadata for the path

---

### isFile

Checks if a given path is a file.

An error will be thrown in the following situations:

- The current process lacks permissions to read at `path`.
- Some other I/O error occurred.

#### Parameters

- `path` The file path to check

#### Returns

- If the path is a file or not

---

### isDir

Checks if a given path is a directory.

An error will be thrown in the following situations:

- The current process lacks permissions to read at `path`.
- Some other I/O error occurred.

#### Parameters

- `path` The directory path to check

#### Returns

- If the path is a directory or not

---

### move

Moves a file or directory to a new path.

Throws an error if a file or directory already exists at the target path.
This can be bypassed by passing `true` as the third argument, or a dictionary of options.
Refer to the documentation for `WriteOptions` for specific option keys and their values.

An error will be thrown in the following situations:

- The current process lacks permissions to read at `from` or write at `to`.
- The new path exists on a different mount point.
- Some other I/O error occurred.

#### Parameters

- `from` The path to move from

- `to` The path to move to

- `overwriteOrOptions` Options for the target path, such as if should be overwritten if it already exists

---

### copy

Copies a file or directory recursively to a new path.

Throws an error if a file or directory already exists at the target path.
This can be bypassed by passing `true` as the third argument, or a dictionary of options.
Refer to the documentation for `WriteOptions` for specific option keys and their values.

An error will be thrown in the following situations:

- The current process lacks permissions to read at `from` or write at `to`.
- Some other I/O error occurred.

#### Parameters

- `from` The path to copy from

- `to` The path to copy to

- `overwriteOrOptions` Options for the target path, such as if should be overwritten if it already exists

---

## Types

### MetadataPermissions

Permissions for the given file or directory.

This is a dictionary that will contain the following values:

- `readOnly` - If the target path is read-only or not

---

### Metadata

Metadata for the given file or directory.

This is a dictionary that will contain the following values:

- `kind` - If the target path is a `file`, `dir` or `symlink`
- `exists` - If the target path exists
- `createdAt` - The timestamp represented as a `DateTime` object at which the file or directory was created
- `modifiedAt` - The timestamp represented as a `DateTime` object at which the file or directory was last modified
- `accessedAt` - The timestamp represented as a `DateTime` object at which the file or directory was last accessed
- `permissions` - Current permissions for the file or directory

Note that timestamps are relative to the unix epoch, and
may not be accurate if the system clock is not accurate.

---

### WriteOptions

Options for filesystem APIs what write to files and/or directories.

This is a dictionary that may contain one or more of the following values:

- `overwrite` - If the target path should be overwritten or not, in the case that it already exists

---
