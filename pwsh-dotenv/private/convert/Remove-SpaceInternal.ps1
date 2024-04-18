#requires -Version 5
Set-StrictMode -Version Latest

function Remove-SpaceInternal {
    [CmdletBinding()]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    param(
        [string]$InputObject,
        [switch]$TrimStart,
        [switch]$TrimEnd,
        [switch]$IncludeNewLine
    )

    if ($IncludeNewLine) {
        $RemoveChar = " `t`f`v`n`r"
    }
    else {
        $RemoveChar = " `t`f`v"
    }

    if ($TrimStart -and $TrimEnd) {
        $InputObject.Trim($RemoveChar)
    }
    elseif ($TrimStart) {
        $InputObject.TrimStart($RemoveChar)
    }
    elseif ($TrimEnd) {
        $InputObject.TrimEnd($RemoveChar)
    }
}
