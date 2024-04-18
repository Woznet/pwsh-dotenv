#requires -Version 5
Set-StrictMode -Version Latest

Set-Variable -Scope script -Option None -Name ModuleRoot -Value $PSScriptRoot

(Get-ChildItem -Path "$ModuleRoot/private/*.ps1" -Recurse -ErrorAction SilentlyContinue) | Sort-Object DirectoryName, Name | ForEach-Object {
    . $_.FullName
}


$Export_Func = [System.Collections.Generic.List[string]]::new()
(Get-ChildItem -Path "$ModuleRoot/public/*.ps1" -Recurse -ErrorAction SilentlyContinue) | Sort-Object DirectoryName, Name | ForEach-Object {
    . $_.FullName
    $Export_Func.Add($_.BaseName)
}

Initialize-Internal

Export-ModuleMember -Function @($Export_Func) -Alias '*'
