$ErrorActionPreference = 'Stop'

$api_key = Read-Host "Enter a API Key" -MaskInput

Push-Location $PSScriptRoot

Publish-Module -Path pwsh-dotenv -NugetAPIKey $api_key -Verbose -WhatIf
# Publish-Module -Path pwsh-dotenv -NugetAPIKey $api_key -Verbose

Pop-Location
