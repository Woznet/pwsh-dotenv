#requires -Version 5
Set-StrictMode -Version Latest

function Expand-EscapesInternal {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [string]$InputObject
    )
    return $InputObject.Replace('\r', "`r").Replace('\n', "`n")
}
