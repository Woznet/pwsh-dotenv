#requires -Version 5
Set-StrictMode -Version Latest

function Get-SimpleValueInternal {
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [string]$InputObject
    )

    # split newline
    $Value, $Tail = Split-LineInternal $InputObject
    # split comment
    $Value = ($Value -split '#', 2)[0].Trim()
    # $Value = ($Value -split "[ \t\f\v]+#", 2)[0].Trim()

    $Env_Entry = [EnvEntry]::new($Value, [EnumQuoteTypes]::UNQUOTED)

    return ($Env_Entry, $Tail);
}
