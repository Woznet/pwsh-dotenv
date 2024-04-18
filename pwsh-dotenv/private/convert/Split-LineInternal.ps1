#requires -Version 5
Set-StrictMode -Version Latest

function Split-LineInternal {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string]$InputObject
    )

    $Lines = $InputObject -split '\n', 2
    $First = $Lines[0]
    $Second = ''
    if (1 -lt $Lines.Count) {
        $Second = $Lines[1]
    }

    return ($First, $Second)
}
