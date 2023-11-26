
$TestResults = Invoke-Pester $PSScriptRoot -Passthru

# $TestResults

If (0 -lt $TestResults.FailedCount){
    exit 1
}
exit 0
