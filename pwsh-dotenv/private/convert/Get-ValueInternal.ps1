#requires -Version 5
Set-StrictMode -Version Latest

function Get-ValueInternal {
    [CmdletBinding()]
    [OutputType([Object[]])]
    Param (
        [string]$InputObject
    )
    if ("" -eq $InputObject) {
        return ([EnvEntry]::new("", $false), "");
    }
    $prefix = Get-QuotePrefixInternal $InputObject
    if ("" -eq $prefix) {
        return (Get-SimpleValueInternal $InputObject);
    }
    else {
        return (Get-QuotedValueInternal $InputObject $prefix);
    }
}
