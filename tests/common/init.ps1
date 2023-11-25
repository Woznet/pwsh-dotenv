$here = Split-Path -Parent $MyInvocation.MyCommand.Path

. "$here/funcitons.ps1"

$TestRoot = Resolve-Path "$here/.."

$ModuleRoot = Resolve-Path (joinpaths (getclosestdir $here "tests") ".." "pwsh-dotenv")
$ModulePath = (Join-Path $ModuleRoot "pwsh-dotenv.psm1")

Import-Module $ModulePath -Force


