#requires -Version 5
Set-StrictMode -Version Latest

function Remove-LineCommentInternal {
    [CmdletBinding()]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function')]
    Param(
        [string]$InputObject
    )
    Begin {

        function trimComment {
            param($Str)
            $Str = $Str.TrimStart()
            if ('' -eq $Str) {
                return $Str
            }
            if ('#' -ne $Str[0]) {
                return $Str
            }
            # split newline
            $First, $Tail = Split-LineInternal $Str
            return $Tail
        }
    }
    Process {
        $Str = $InputObject
        if ($null -eq $Str) {
            $Str = ''
        }
        $Prev_Str = $Str
        while ($True) {
            $Str = trimComment $Str
            if ('' -eq $Str) {
                return $Str;
            }
            if ($Prev_Str -eq $Str) {
                return $Str;
            }
            $Prev_Str = $Str
        }
    }
}
