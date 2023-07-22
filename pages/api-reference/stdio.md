# Stdio

Built-in standard input / output & utility functions

#### Example usage

```lua
local stdio = require("@lune/stdio")

-- Prompting the user for basic input
local text: string = stdio.prompt("text", "Please write some text")
local confirmed: boolean = stdio.prompt("confirm", "Please confirm this action")

-- Writing directly to stdout or stderr, without the auto-formatting of print/warn/error
stdio.write("Hello, ")
stdio.write("World! ")
stdio.write("All on the same line")
stdio.ewrite("\nAnd some error text, too")
```

## Functions

### prompt

Prompts for user input using the wanted kind of prompt:

-   `"text"` - Prompts for a plain text string from the user
-   `"confirm"` - Prompts the user to confirm with y / n (yes / no)
-   `"select"` - Prompts the user to select _one_ value from a list
-   `"multiselect"` - Prompts the user to select _one or more_ values from a list
-   `nil` - Equivalent to `"text"` with no extra arguments

#### Parameters

-   `kind` The kind of prompt to use

-   `message` The message to show the user

-   `defaultOrOptions` The default value for the prompt, or options to choose from for selection
    prompts

---

### color

Return an ANSI string that can be used to modify the persistent output color.

Pass `"reset"` to get a string that can reset the persistent output color.

#### Example usage

```lua
stdio.write(stdio.color("red"))
print("This text will be red")
stdio.write(stdio.color("reset"))
print("This text will be normal")
```

#### Parameters

-   `color` The color to use

#### Returns

-   A printable ANSI string

---

### style

Return an ANSI string that can be used to modify the persistent output style.

Pass `"reset"` to get a string that can reset the persistent output style.

#### Example usage

```lua
stdio.write(stdio.style("bold"))
print("This text will be bold")
stdio.write(stdio.style("reset"))
print("This text will be normal")
```

#### Parameters

-   `style` The style to use

#### Returns

-   A printable ANSI string

---

### format

Formats arguments into a human-readable string with syntax highlighting for tables.

#### Parameters

-   `...` The values to format

#### Returns

-   The formatted string

---

### write

Writes a string directly to stdout, without any newline.

#### Parameters

-   `s` The string to write to stdout

---

### ewrite

Writes a string directly to stderr, without any newline.

#### Parameters

-   `s` The string to write to stderr

---
