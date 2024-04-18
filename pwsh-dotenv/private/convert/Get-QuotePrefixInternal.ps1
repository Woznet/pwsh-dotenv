#requires -Version 5
Set-StrictMode -Version Latest

function Get-QuotePrefixInternal {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string]$InputObject
    )
    if ($InputObject.StartsWith('"')) {
        return '"'
    }
    elseif ($InputObject.StartsWith("'")) {
        return "'"
    }
    return '';
}
