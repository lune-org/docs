# Serde

Built-in library for:

-   serialization & deserialization
-   encoding & decoding
-   compression

#### Example usage

```lua
local fs = require("@lune/fs")
local serde = require("@lune/serde")

-- Parse different file formats into lua tables
local someJson = serde.decode("json", fs.readFile("myFile.json"))
local someToml = serde.decode("toml", fs.readFile("myFile.toml"))
local someYaml = serde.decode("yaml", fs.readFile("myFile.yaml"))

-- Write lua tables to files in different formats
fs.writeFile("myFile.json", serde.encode("json", someJson))
fs.writeFile("myFile.toml", serde.encode("toml", someToml))
fs.writeFile("myFile.yaml", serde.encode("yaml", someYaml))
```

## Functions

### encode

Encodes the given value using the given format.

Currently supported formats:

| Name   | Learn More           |
| :----- | :------------------- |
| `json` | https://www.json.org |
| `yaml` | https://yaml.org     |
| `toml` | https://toml.io      |

#### Parameters

-   `format` The format to use

-   `value` The value to encode

-   `pretty` If the encoded string should be human-readable, including things such as newlines and
    spaces. Only supported for json and toml formats, and defaults to false

#### Returns

-   The encoded string

---

### decode

Decodes the given string using the given format into a lua value.

Currently supported formats:

| Name   | Learn More           |
| :----- | :------------------- |
| `json` | https://www.json.org |
| `yaml` | https://yaml.org     |
| `toml` | https://toml.io      |

#### Parameters

-   `format` The format to use

-   `encoded` The string to decode

#### Returns

-   The decoded lua value

---

### compress

Compresses the given string using the given format.

Currently supported formats:

| Name     | Learn More                        |
| :------- | :-------------------------------- |
| `brotli` | https://github.com/google/brotli  |
| `gzip`   | https://www.gnu.org/software/gzip |
| `lz4`    | https://github.com/lz4/lz4        |
| `zlib`   | https://www.zlib.net              |

#### Parameters

-   `format` The format to use

-   `s` The string to compress

#### Returns

-   The compressed string

---

### decompress

Decompresses the given string using the given format.

Currently supported formats:

| Name     | Learn More                        |
| :------- | :-------------------------------- |
| `brotli` | https://github.com/google/brotli  |
| `gzip`   | https://www.gnu.org/software/gzip |
| `lz4`    | https://github.com/lz4/lz4        |
| `zlib`   | https://www.zlib.net              |

#### Parameters

-   `format` The format to use

-   `s` The string to decompress

#### Returns

-   The decompressed string

---
