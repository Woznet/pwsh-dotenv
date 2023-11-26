
# pwsh-dotenv

pwsh-dotenv to load environment variables from `.env` .


## Installation

```powershell
Install-Module -Name pwsh-dotenv
```

## Usage

* Functions:
  * `Import-Dotenv` - Loads a .env file and loads it into environment variables.
  * `Read-Dotenv` - Loads a .env file and converts it into a Hashtable.
  * `ConvertFrom-Dotenv` - Converts a string in .env format into a Hashtable.

### Basic Usage

- To load the `.env` file in the current directory and reflect it as environment variables, use the following command:

```powershell
Import-Dotenv
```

Alternatively, you can use the short form:

```powershell
dotenv
```

### Specifying a Particular File

- To load a specific `.env` file (for example, `test.env`), use the `-Path` option.

```powershell
Import-Dotenv -Path test.env
```

### Ignore Error Option

- To load the file while ignoring errors if the file does not exist, use the `-SkipReadErrorCheck` option.

```powershell
Import-Dotenv -Path test.env -SkipReadErrorCheck
```

### Overwriting Existing Environment Variables

- To overwrite existing environment variables when loading a `.env` file, use the `-AllowClobber` option.

```powershell
Import-Dotenv -AllowClobber
```

### Loading .env File

- To load a `.env` file and return it as a Hashtable, use the following command:

```powershell
$env = Read-Dotenv
```

This command reads the contents of the `.env` file and returns it as a Hashtable object containing key-value pairs.

### Converting .env Format Strings

- To convert a string in `.env` format to a Hashtable, use the following command:

```powershell
$env = "TEST1=1`nTEST2=2" | ConvertFrom-Dotenv
```

This command takes the specified string format `.env` data (in this example, `TEST1=1` and `TEST2=2`) and returns it as a Hashtable object containing key-value pairs.


## .env File Specification

### Format

- The `.env` file is written in a `key=value` format.
- Each line is divided into a key and a value by a single equals sign (`=`).

### Key Specifications

- Keys consist of letters (uppercase and lowercase), numbers, and underscores (`_`).
- The first character of a key must be a letter or an underscore.
- Key pattern: `[a-zA-Z_][a-zA-Z0-9_]*`

### Comments
- Lines starting with `#` are treated as comments and ignored until the end of the line.

### Specifying Values

- Values can be enclosed in double quotes (`"`) or single quotes (`'`).
- When enclosed in quotes, values can span multiple lines.
- Text following a `#` is treated as a comment.

### Special Characters and Escaping

- The `$` symbol can be used to reference existing environment variables.
- Use `\` to escape special characters.
- When enclosed in single quotes, variable expansion and special character escaping do not occur.

### Variable Expansion

- Shell-style variable expansion (`${variable}`) is possible.
- Default value specification: Use `${variable:-default_value}` to use a default value if the variable is unset or empty.

### Example of Writing a .env File

```env
# Can be enclosed in double quotes
ABC="123"
# Can be enclosed in single quotes
DEF='456'
# Multi-line values
GHI="First line
Second line
Third line
"

# Example of comments
J="123" # This is a comment
K=456# This is also a comment

# Environment variable expansion
L=$PWD
M="$PWD"
# No expansion in single quotes
N='$PWD'

# Escaping special characters
O="\"" # Double quote
P="\$" # Dollar sign
Q="\'" # Single quote
R="\\" # Backslash
S="\n" # New line (LF)
T="\r" # Carriage return (CR)
U="\t" # Tab

# Variable expansion
V=${PWD}
W="${PWD}"
# Default value specification
X="${NOTFOUND:-default_value}"
Y="${NOTFOUND:-$PWD/bin}"
Z="${NOTFOUND:-${NESTED_NOTFOUND:-default_value}}"
```

