# Regex

Built-in library for regular expressions

#### Example usage

```lua
local Regex = require("@lune/regex")

local re = Regex.new("hello")

if re:isMatch("hello, world!") then
	print("Matched!")
end

local caps = re:captures("hello, world! hello, again!")

print(#caps) -- 2
print(caps:get(1)) -- "hello"
print(caps:get(2)) -- "hello"
print(caps:get(3)) -- nil
```

## Constructors

### new

Creates a new `Regex` from a given string pattern.

#### Errors

This constructor throws an error if the given pattern is invalid.

#### Parameters

-   `pattern` `string` The string pattern to use

#### Returns

-   `Regex` The new Regex object

---

## Methods

### isMatch

Check if the given text matches the regular expression.

This method may be slightly more efficient than calling `find` if you only need to know if the text
matches the pattern.

#### Parameters

-   `self` Regex

-   `text` `string` The text to search

#### Returns

-   `boolean` Whether the text matches the pattern

---

### find

Finds the first match in the given text.

Returns `nil` if no match was found.

#### Parameters

-   `self` Regex

-   `text` `string` The text to search

#### Returns

-   `RegexMatch?` The match object

---

### captures

Finds all matches in the given text as a `RegexCaptures` object.

Returns `nil` if no matches are found.

#### Parameters

-   `self` Regex

-   `text` `string` The text to search

#### Returns

-   `RegexCaptures?` The captures object

---

### split

Splits the given text using the regular expression.

#### Parameters

-   `self` Regex

-   `text` `string` The text to split

#### Returns

-   `{ string }` The split text

---

### replace

Replaces the first match in the given text with the given replacer string.

#### Parameters

-   `self` Regex

-   `haystack` `string` The text to search

-   `replacer` `string` The string to replace matches with

#### Returns

-   `string` The text with the first match replaced

---

### replaceAll

Replaces all matches in the given text with the given replacer string.

#### Parameters

-   `self` Regex

-   `haystack` `string` The text to search

-   `replacer` `string` The string to replace matches with

#### Returns

-   `string` The text with all matches replaced

---

# RegexCaptures

Captures from a regular expression.

## Methods

### get

Returns the match at the given index, if one exists.

#### Parameters

-   `self` RegexCaptures

-   `index` `number` The index of the match to get

#### Returns

-   `RegexMatch` The match, if one exists

---

### group

Returns the match for the given named match group, if one exists.

#### Parameters

-   `self` RegexCaptures

-   `group` `string` The name of the group to get

#### Returns

-   `RegexMatch` The match, if one exists

---

### format

Formats the captures using the given format string.

#### Example usage

```lua
local regex = require("@lune/regex")

local re = regex.new("(?<day>[0-9]{2})-(?<month>[0-9]{2})-(?<year>[0-9]{4})")

local caps = re:captures("On 14-03-2010, I became a Tenneessee lamb.");
assert(caps ~= nil, "Example pattern should match example text")

local formatted = caps:format("year=$year, month=$month, day=$day")
print(formatted) -- "year=2010, month=03, day=14"
```

#### Parameters

-   `self` RegexCaptures

-   `format` `string` The format string to use

#### Returns

-   `string` The formatted string

---

# RegexMatch

A match from a regular expression.

Contains the following values:

-   `start` -- The start index of the match in the original string.
-   `finish` -- The end index of the match in the original string.
-   `text` -- The text that was matched.
-   `len` -- The length of the text that was matched.
