#Requires -Version 5
#Requires -Module Pester

(Get-ChildItem -Path "$PSScriptRoot/assertions/*.ps1" -Recurse -ErrorAction SilentlyContinue ) | Sort-Object DirectoryName,Name | ForEach-Object {
    . $_.Fullname
}

