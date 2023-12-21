$ErrorActionPreference = 'Stop'

$ModuleVersion = '1.0.3'

$module_root = Join-Path $PSScriptRoot "pwsh-dotenv"
$manifest_path = Join-Path $module_root pwsh-dotenv.psd1


$export_func = @(Get-ChildItem -Path (Join-Path $module_root public) -Recurse  -Filter "*.ps1" -File | ForEach-Object {
    if($_.Name -ne "alias.ps1"){
        $_.Name -replace "\.ps1$",""
    }
})

$export_alias = @(Get-Content (Join-Path (Join-Path $module_root public) alias.ps1) | ForEach-Object {
    $cmd = $_.Trim()
    if(-not [string]::IsNullOrWhiteSpace($cmd)){
        if($cmd -notmatch "^#"){
            $prams = ($cmd -split "\s+")
            if($prams[1] -eq "-Name"){
                $prams[2]
            }
        }
    }
})

$p = @{
    Path = $manifest_path
    RootModule = "pwsh-dotenv.psm1"
    FunctionsToExport = $export_func
    AliasesToExport = $export_alias
    ModuleVersion = $ModuleVersion
}

Update-ModuleManifest @p

