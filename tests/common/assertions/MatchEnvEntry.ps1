#Requires -Module Pester
function Should-MatchEnvEntry ($ActualValue, $ExpectedValue, [switch] $Negate, [string] $Because) {
    <#
    .SYNOPSIS
        Asserts if hashtable contains only the expected value
    .EXAMPLE
        @{name=1} | Should -MatchEnvEntry @{name=1}
    #>

    $convert_from_enventry = {
        param($env)
        $map = [ordered]@{}
        $map["Name"] = $env.Name
        $map["Value"] = $env.Value
        $map["QuoteType"] = $env.QuoteType
        $map
    }

    $actual = @($ActualValue | ForEach-Object {
        & $convert_from_enventry $_
    })

    $expected = @($ExpectedValue | ForEach-Object {
        & $convert_from_enventry $_
    })

    $ActualJson = $actual  | ConvertTo-Json -Compress
    $ExpectedJson = $expected | ConvertTo-Json -Compress

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

Add-ShouldOperator -Name MatchEnvEntry `
    -InternalName 'Should-MatchEnvEntry' `
    -Test ${function:Should-MatchEnvEntry} `
    -SupportsArrayInput
