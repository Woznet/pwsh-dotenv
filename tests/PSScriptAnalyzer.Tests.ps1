# #requires -Version 5
# #requires -Modules PSScriptAnalyzer
# Set-StrictMode -Version Latest

# $repoRoot = (Resolve-Path "$PSScriptRoot\..").Path;
# $lib_name = $((Get-Item -LiteralPath "$repoRoot").Name)
# $src_dir = "$repoRoot/$lib_name/"
# $target = Get-ChildItem -Path "$src_dir" -Recurse -File -Include ('*.ps1','*.psm1') | Sort-Object DirectoryName,Name

# Describe 'Linting\PSScriptAnalyzer' {
#     It "File <Name> passes PSScriptAnalyzer rules" -TestCases @(
#         $target | ForEach-Object {@{Name=$_.Name;FullName=$_.FullName}}
#     ) {
#         param($Name,$FullName)
#         $result = Invoke-ScriptAnalyzer -Path $FullName -Severity Warning -ExcludeRule PSReviewUnusedParameter | Select-Object -ExpandProperty Message
#         $result | Should -BeNullOrEmpty
#     }
# }
