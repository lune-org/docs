---
title: Serde
---

Built-in library for:

- serialization & deserialization
- encoding & decoding
- compression

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

See [`EncodeDecodeFormat`] for a list of supported formats.

#### Parameters

- `format` The format to use

- `value` The value to encode

- `pretty` If the encoded string should be human-readable, including things such as newlines and
  spaces. Only supported for json and toml formats, and defaults to false

#### Returns

- The encoded string

---

### decode

Decodes the given string using the given format into a lua value.

See [`EncodeDecodeFormat`] for a list of supported formats.

#### Parameters

- `format` The format to use

- `encoded` The string to decode

#### Returns

- The decoded lua value

---

### compress

Compresses the given string using the given format.

See [`CompressDecompressFormat`] for a list of supported formats.

#### Parameters

- `format` The format to use

- `s` The string to compress

#### Returns

- The compressed string

---

### decompress

Decompresses the given string using the given format.

See [`CompressDecompressFormat`] for a list of supported formats.

#### Parameters

- `format` The format to use

- `s` The string to decompress

#### Returns

- The decompressed string

---

### hash

Hashes the given message using the given algorithm and returns the hash as a hex string.

See [`HashAlgorithm`] for a list of supported algorithms.

#### Parameters

- `algorithm` The algorithm to use

- `message` The message to hash

#### Returns

- The hash as a hex string

---

### hmac

Hashes the given message using HMAC with the given secret and algorithm, returning the hash as a
base64 string.

See [`HashAlgorithm`] for a list of supported algorithms.

#### Parameters

- `algorithm` The algorithm to use

- `message` The message to hash

- `secret` string | buffer

#### Returns

- The hash as a base64 string

---

## Types

### EncodeDecodeFormat

A serialization/deserialization format supported by the Serde library.

Currently supported formats:

| Name   | Learn More           |
| :----- | :------------------- |
| `json` | https://www.json.org |
| `yaml` | https://yaml.org     |
| `toml` | https://toml.io      |

---

### CompressDecompressFormat

A compression/decompression format supported by the Serde library.

Currently supported formats:

| Name     | Learn More                        |
| :------- | :-------------------------------- |
| `brotli` | https://github.com/google/brotli  |
| `gzip`   | https://www.gnu.org/software/gzip |
| `lz4`    | https://github.com/lz4/lz4        |
| `zlib`   | https://www.zlib.net              |

---

### HashAlgorithm

A hash algorithm supported by the Serde library.

Currently supported algorithms:

| Name       | Learn More                           |
| :--------- | :----------------------------------- |
| `md5`      | https://en.wikipedia.org/wiki/MD5    |
| `sha1`     | https://en.wikipedia.org/wiki/SHA-1  |
| `sha224`   | https://en.wikipedia.org/wiki/SHA-2  |
| `sha256`   | https://en.wikipedia.org/wiki/SHA-2  |
| `sha384`   | https://en.wikipedia.org/wiki/SHA-2  |
| `sha512`   | https://en.wikipedia.org/wiki/SHA-2  |
| `sha3-224` | https://en.wikipedia.org/wiki/SHA-3  |
| `sha3-256` | https://en.wikipedia.org/wiki/SHA-3  |
| `sha3-384` | https://en.wikipedia.org/wiki/SHA-3  |
| `sha3-512` | https://en.wikipedia.org/wiki/SHA-3  |
| `blake3`   | https://en.wikipedia.org/wiki/BLAKE3 |

---
