#requires -Version 5
Set-StrictMode -Version Latest

function Split-KeyValueInternal {
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [string]$InputObject
    )

    $Key, $Tail = Get-KeyNameInternal $InputObject
    if ('' -eq $Key) {
        $First, $Tail = Split-LineInternal $Tail
        Write-Warning -Message "invalid line:$First"
        return ($null, $Tail)
    }

    $Env_Entry, $Tail = Get-ValueInternal $Tail

    if ($Key -notmatch "${script:REG_START}${script:REG_KEY}${script:REG_END}") {
        Write-Error ('unexpected character "{0}" in variable name near {1}' -f $Key, $InputObject) -Category ParserError
        return ($null, $Tail)
    }

    $Env_Entry.Name = $Key;

    return ($Env_Entry, $Tail)
}
