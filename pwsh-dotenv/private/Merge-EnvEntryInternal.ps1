#requires -Version 5
Set-StrictMode -Version Latest

function Merge-EnvEntryInternal {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0 , ValueFromPipeline)]
        [EnvEntry]$Entry,
        [System.Collections.IDictionary]$InitialEnv,
        [switch]$AllowClobber
    )
    Begin {
        $Envs = New-HashTableInternal
        if ($null -eq $InitialEnv) {
            $InitialEnv = @{}
        }
    }
    Process {
        if ((-not $AllowClobber) -and $InitialEnv.Contains($Entry.Name)) {
            Write-Verbose ('Skip Env: {0}' -f $Entry)
            return
        }
        if ($Envs.Contains($Entry.Name)) {
            Write-Verbose ('Overwrite Env: {0}' -f $Entry)
        }
        $Envs[$Entry.Name] = $Entry.GetValue({
                param($Key)
                if ($Envs.Contains($Key)) {
                    return $Envs[$Key]
                }
                if ($InitialEnv.Contains($Key)) {
                    return $InitialEnv[$Key]
                }
                return ''
            })
    }
    End {
        $Envs
    }
}
