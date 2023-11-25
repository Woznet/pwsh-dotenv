#Requires -Module Pester
function Should-MatchHashtable ($ActualValue, $ExpectedValue, [switch] $Negate, [string] $Because) {
    <#
    .SYNOPSIS
        Asserts if hashtable contains only the expected value
    .EXAMPLE
        @{name=1} | Should -MatchHashtable @{name=1}
    #>

    $convert_json = {
        param($hash)
        $map = New-Object System.Collections.Specialized.OrderedDictionary ([StringComparer]::Ordinal)
        $keys = New-Object System.Collections.ArrayList
        $keys.AddRange($hash.Keys)
        $keys.Sort([StringComparer]::Ordinal)
        foreach ($key in $keys) {
            $map[$key] = $hash[$key];
        }
        return $map | ConvertTo-Json -Compress
    }

    $ActualJson = & $convert_json $ActualValue
    $ExpectedJson = & $convert_json $ExpectedValue

    [bool] $succeeded = $ExpectedJson -eq $ActualJson
    if ($Negate) { $succeeded = -not $succeeded }

    if (-not $succeeded) {
        if ($Negate) {
            $failureMessage = "Expected $ExpectedJson to be different from the actual value$(if($Because) { ", because $Because"}), but got exactly the same value."
        }
        else {
            $failureMessage = "Expected $ExpectedJson$(if($Because) { ", because $Because"}), but got $ActualJson."
        }
    }

    return [pscustomobject]@{
        Succeeded      = $succeeded
        FailureMessage = $failureMessage
    }
}

Add-ShouldOperator -Name MatchHashtable `
    -InternalName 'Should-MatchHashtable' `
    -Test ${function:Should-MatchHashtable}
