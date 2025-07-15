---
title: Net
---

Built-in library for network access

#### Example usage

```luau
local net = require("@lune/net")
local serde = require("@lune/serde")

-- Sending a web request
local response = net.request("https://www.google.com")
print(response.ok)
print(response.statusCode, response.statusMessage)
print(response.headers)

-- Using a JSON web API
local response = net.request({
	url = "https://dummyjson.com/products/add",
	method = "POST",
	headers = { ["Content-Type"] = "application/json" },
	body = serde.encode("json", {
		title = "Cool Pencil",
	})
})
local product = serde.decode("json", response.body)
print(product.id, "-", product.title)

-- Starting up an http server
net.serve(8080, function(request)
	return {
		status = 200,
		body = "Echo:\n" .. request.body,
	}
end)

-- Writing to a plain TCP stream
local conn = net.tcp.connect("example.com", 80)

conn:write("GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")
```

## Functions

### request

Sends an HTTP request using the given url and / or parameters, and returns a dictionary that describes the response received.

Only throws an error if a miscellaneous network or I/O error occurs, never for unsuccessful status codes.

#### Parameters

- `config` The URL or request config to use

#### Returns

- A dictionary representing the response for the request

---

### socket

Connects to a web socket at the given URL.

Throws an error if the server at the given URL does not support
web sockets, or if a miscellaneous network or I/O error occurs.

#### Parameters

- `url` The URL to connect to

#### Returns

- A web socket handle

---

### serve

Creates an HTTP server that listens on the given `port`.

This will **_not_** block and will keep listening for requests on the given `port`
until the `stop` function on the returned `ServeHandle` has been called.

#### Parameters

- `port` The port to use for the server

- `handlerOrConfig` The handler function or config to use for the server

#### Returns

- ServeHandle

---

### urlEncode

Encodes the given string using URL encoding.

#### Parameters

- `s` The string to encode

- `binary` If the string should be treated as binary data and/or is not valid utf-8. Defaults to false

#### Returns

- The encoded string

---

### urlDecode

Decodes the given string using URL decoding.

#### Parameters

- `s` The string to decode

- `binary` If the string should be treated as binary data and/or is not valid utf-8. Defaults to false

#### Returns

- The decoded string

---

## Types

### FetchParamsOptions

Extra options for `FetchParams`.

This is a dictionary that may contain one or more of the following values:

- `decompress` - If the request body should be automatically decompressed when possible. Defaults to `true`

---

### FetchParams

Parameters for sending network requests with `net.request`.

This is a dictionary that may contain one or more of the following values:

- `url` - The URL to send a request to. This is always required
- `method` - The HTTP method verb, such as `"GET"`, `"POST"`, `"PATCH"`, `"PUT"`, or `"DELETE"`. Defaults to `"GET"`
- `body` - The request body
- `query` - A table of key-value pairs representing query parameters in the request path
- `headers` - A table of key-value pairs representing headers
- `options` - Extra options for things such as automatic decompression of response bodies

---

### FetchResponse

Response type for sending network requests with `net.request`.

This is a dictionary containing the following values:

- `ok` - If the status code is a canonical success status code, meaning within the range 200 -> 299
- `statusCode` - The status code returned for the request
- `statusMessage` - The canonical status message for the returned status code, such as `"Not Found"` for status code 404
- `headers` - A table of key-value pairs representing headers
- `body` - The request body, or an empty string if one was not given

---

### ServeRequest

Data type for requests in `net.serve`.

This is a dictionary containing the following values:

- `path` - The path being requested, relative to the root. Will be `/` if not specified
- `query` - A table of key-value pairs representing query parameters in the request path
- `method` - The HTTP method verb, such as `"GET"`, `"POST"`, `"PATCH"`, `"PUT"`, or `"DELETE"`. Will always be uppercase
- `headers` - A table of key-value pairs representing headers
- `body` - The request body, or an empty string if one was not given

---

### ServeResponse

Response type for requests in `net.serve`.

This is a dictionary that may contain one or more of the following values:

- `status` - The status code for the request, in the range `100` -> `599`
- `headers` - A table of key-value pairs representing headers
- `body` - The response body

---

### ServeConfig

Configuration for `net.serve`.

This may contain one of or more of the following values:

- `address` for setting the IP address to serve from. Defaults to the loopback interface (`http://localhost`).
- `handleRequest` for handling normal http requests, equivalent to just passing a function to `net.serve`
- `handleWebSocket` for handling web socket requests, which will receive a `WebSocket` object as its first and only parameter

When setting `address`, the `handleRequest` callback must also be defined.

#### Example Usage

```luau
net.serve(8080, {
	address = "http://0.0.0.0",
	handleRequest = function(request)
		return {
			status = 200,
			body = "Echo:\n" .. request.body,
		}
	end
})
```

---

### ServeHandle

A handle to a currently running web server, containing a single `stop` function to gracefully shut down the web server.

---

### WebSocket

A reference to a web socket connection.

The web socket may be in either an "open" or a "closed" state, changing its current behavior.

When open:

- Any function on the socket such as `send`, `next` or `close` can be called without erroring
- `next` can be called to yield until the next message is received or the socket becomes closed

When closed:

- `next` will no longer return any message(s) and instead instantly return nil
- `send` will throw an error stating that the socket has been closed

Once the websocket has been closed, `closeCode` will no longer be nil, and will be populated with a close
code according to the [WebSocket specification](https://www.iana.org/assignments/websocket/websocket.xhtml).
This will be an integer between 1000 and 4999, where 1000 is the canonical code for normal, error-free closure.

---

### TcpConfig

Configuration options for a TCP stream.

#### Example Usage

```luau
-- Plain TCP connection
local stream = net.tcp.connect("example.com", 80)

-- TLS connection (shorthand)
local stream = net.tcp.connect("example.com", 443, true)

-- TLS connection (explicit config)
local stream = net.tcp.connect("example.com", 443, { tls = true })

-- Connection with custom TTL
local stream = net.tcp.connect("192.168.1.100", 8080, {
	tls = false,
	ttl = 128
})
```

---

### TcpStream

A plain TCP stream, which may also be backed by a TLS connection.

#### Example Usage

```luau
local net = require("@lune/net")

local conn = net.tcp.connect("example.com", 80)

conn:write("GET / HTTP/1.1\r\nHost: example.com\r\n\r\n")

local response = conn:read()
print(response)

conn:close()
```

---

# Tcp

TCP primitives for the `net` library

Provides low-level TCP socket functionality for creating custom network
protocols or communicating with services that don't use HTTP - for all
HTTP usage, please use the `request` and `serve` HTTP functions instead.

## Functions

### connect

Connects to the given host and port, returning a `TcpStream`.

For additional details, see the documentation for the `TcpConfig` and `TcpStream` types.

Will throw an error if the connection fails.

#### Parameters

- `host` The host to connect to, either a DNS name or IP address

- `port` The port to connect to

- `config` The optional configuration to use for the stream

#### Returns

- A connected TcpStream ready for reading and writing

---
