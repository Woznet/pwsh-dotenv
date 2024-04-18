#requires -Version 5
Set-StrictMode -Version Latest

function ConvertFrom-Dotenv {
    <#
    .SYNOPSIS
        Converts a dotenv-formatted(.env) string into a hash table or a EnvEntry object.
    .DESCRIPTION
        This cmdlet converts a dotenv(.env) formatted string into either a Hashtable or a EnvEntry array.
    .EXAMPLE
        PS C:\> ConvertFrom-Dotenv "ABC=1`nDEF=2"

        ----                           -----
        ABC                            1
        DEF                            3

    #>
    [CmdletBinding(DefaultParametersetName = 'Hashtable')]
    [OutputType([hashtable], ParameterSetName = 'Hashtable')]
    [OutputType('EnvEntry[]', ParameterSetName = 'EnvEntry')]
    param(
        # Specifies the .env strings to convert to  a Hashtable or a EnvEntry array.
        [Parameter(Position = 0 , ValueFromPipeline, ParameterSetName = 'Hashtable')]
        [Parameter(Position = 0 , ValueFromPipeline, ParameterSetName = 'EnvEntry')]
        [string[]]$InputObject,
        # Environment variables for variable expansion; defaults to retrieving from the Env: drive.
        [Parameter(ParameterSetName = 'Hashtable')]
        [System.Collections.IDictionary]$InitialEnv = (Get-EnvHashtableInternal),
        # Enables the behavior to OVERRIDE environment variables.
        [Parameter(ParameterSetName = 'Hashtable')]
        [switch]$AllowClobber,
        # Converts the Dotenv to an EnvEntry object.
        [Parameter(ParameterSetName = 'EnvEntry')]
        [switch]$AsEnvEntry
    )
    Begin {
        $Dotenv_List = [System.Collections.ArrayList]::new()
        function ParseDotFile ([string]$Str) {
            $Prev_Str = $Str
            while ($true) {
                if ('' -eq $Str) {
                    break;
                }
                $Str = Remove-LineCommentInternal $Str
                $Env_Entry, $Str = Split-KeyValueInternal $Str
                if ($null -ne $Env_Entry) {
                    Write-Debug ('parse dotenv: {0}' -f $Env_Entry)
                    $null = $Dotenv_List.Add($Env_Entry)
                }
                if ($Prev_Str -eq $Str) {
                    break;
                }
                if ($null -eq $Str) {
                    $Str = ''
                }
                $Prev_Str = $Str
            }
        }
    }
    Process {
        $InputObject | ForEach-Object {
            ParseDotFile $_
        }
    }
    End {

        if ($AsEnvEntry) {
            return $Dotenv_List.ToArray()
        }
        else {
            $Envs = New-HashTableInternal
            if ($null -eq $InitialEnv) {
                $InitialEnv = @{}
            }

            $Envs = $Dotenv_List | Merge-EnvEntryInternal -InitialEnv $InitialEnv -AllowClobber:$AllowClobber
            return $Envs;
        }
    }
}
