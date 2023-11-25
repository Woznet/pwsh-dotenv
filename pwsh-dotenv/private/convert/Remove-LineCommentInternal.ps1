#requires -Version 5
Set-StrictMode -Version Latest

function Remove-LineCommentInternal {
    [CmdletBinding()]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function')]
    Param(
        [string]$InputObject
    )
    Process {
        $str = $InputObject.TrimStart()
        if ("" -eq $str) {
            return $str
        }
        if ("#" -ne $str[0]) {
            return $str
        }
        # split newline
        $first, $tail = Split-LineInternal $str
        return $tail
    }
}
