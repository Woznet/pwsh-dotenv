#requires -Version 5
#requires -Modules PSScriptAnalyzer
Set-StrictMode -Version Latest

$repoRoot = (Resolve-Path "$PSScriptRoot\..").Path;
$lib_name = $((Get-Item -LiteralPath "$repoRoot").Name)
$src_dir = "$repoRoot/$lib_name/"
# $target = Get-ChildItem -Path "$src_dir" -Recurse -File -Include ('*.ps1','*.psm1') | Sort-Object DirectoryName,Name


(Invoke-ScriptAnalyzer -Path $src_dir -Recurse -Severity Warning -ExcludeRule PSReviewUnusedParameter)

