#requires -Version 5
Set-StrictMode -Version Latest

function Get-EnvHashTableInternal {
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    param()

    $Envs = New-HashTableInternal
    foreach ($Entry in (Get-ChildItem "${script:EnvDriveName}:")) {
        $Envs[$Entry.Name] = $Entry.Value
    }
    return $Envs
}
