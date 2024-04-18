#requires -Version 5
Set-StrictMode -Version Latest

function Get-KeyNameInternal() {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string]$Str
    )
    if ($Str -notmatch "${script:REG_START}(?:export${script:REG_SPACE}+)?(?<key_name>\w+)${script:REG_SPACE}*=") {
        return ('', $Str)
    }
    $Key = $Matches['key_name'];
    $Tail = $Str.Substring($Matches[0].Length)
    return ($Key, $Tail)
}
