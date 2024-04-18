#requires -Version 5
Set-StrictMode -Version Latest

function Get-ValueInternal {
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [string]$InputObject
    )

    $Str = Remove-SpaceInternal -InputObject $InputObject -TrimStart

    if ('' -eq $Str) {
        return ([EnvEntry]::new('', [EnumQuoteTypes]::UNQUOTED), '');
    }
    $Prefix = Get-QuotePrefixInternal $Str
    if ('' -eq $Prefix) {
        return (Get-SimpleValueInternal $Str);
    }
    else {
        return (Get-QuotedValueInternal $Str $Prefix);
    }
}
