Write-Host "------------------------------------------------------------------------------------------------------------------------------------"

Import-Module "$PSScriptRoot/pwsh-dotenv/pwsh-dotenv.psm1" -Force -Verbose



@"
MULTILINE_VAR="This is a value that     
spans multiple lines"
SINGLELINE_VAR=123
"@ | ConvertFrom-Dotenv | ConvertTo-Json

