#requires -Version 5
Set-StrictMode -Version Latest

function Read-Dotenv {
    <#
    .SYNOPSIS
        Reads a dotenv-formatted file and returns it in Hashtable format.
    .DESCRIPTION
        This cmdlet converts a dotenv(.env) formatted string into either a Hashtable or a EnvEntry array.
    .EXAMPLE
        PS C:\> Read-Dotenv '.env'

        ----                           -----
        ABC                            1
        DEF                            3

    #>
    [CmdletBinding(DefaultParametersetName = 'Hashtable')]
    [OutputType([hashtable], ParameterSetName = 'Hashtable')]
    [OutputType([EnvEntry[]], ParameterSetName = 'EnvEntry')]
    param(
        # Specifies a Path Name of the .env.
        [Parameter(Position = 0 , ValueFromPipeline, ParameterSetName = 'Hashtable')]
        [Parameter(Position = 0 , ValueFromPipeline, ParameterSetName = 'EnvEntry')]
        [ValidateScript({
            if(-not ($_ | Test-Path -PathType Leaf) ){
              throw 'File does not exist'
            }
            return $true
        })]
        [string[]]$Path = '.env',
        # Environment variables for variable expansion; defaults to retrieving from the Env: drive.
        [Parameter(ParameterSetName = 'Hashtable')]
        [System.Collections.IDictionary]$InitialEnv = (Get-EnvHashtableInternal),
        # Enables the behavior to OVERRIDE environment variables.
        [Parameter(ParameterSetName = 'Hashtable')]
        [switch]$AllowClobber,
        # Specifies the encoding type for .env. The default value is UTF-8.
        [Parameter(ParameterSetName = 'Hashtable')]
        [Parameter(ParameterSetName = 'EnvEntry')]
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8,
        # Converts the Dotenv to an EnvEntry object.
        # Ignore errors if the file does not exist.
        [Parameter(ParameterSetName = 'Hashtable')]
        [Parameter(ParameterSetName = 'EnvEntry')]
        [switch]$SkipReadErrorCheck,
        [Parameter(ParameterSetName = 'EnvEntry')]
        [switch]$AsEnvEntry
    )
    Begin {
        function GetDotFileContent ([string]$F) {
            try {
                Get-Content -Path $F -Encoding $Encoding -Raw -ErrorAction Stop
            }
            catch {
                if (-not $SkipReadErrorCheck) {
                    throw $_
                }
                Write-Verbose $_
            }
            return ''
        }

        $Dotenv_Files = [System.Collections.Generic.List[string]]::new();
    }
    Process {
        foreach($File in ($Path | Where-Object { -not ([string]::IsNullOrEmpty($_)) })) {
            $Dotenv_Files.Add($File)
        }
    }
    End {

        $Dotenv_Contents = $Dotenv_Files | ForEach-Object {
            $C = GetDotFileContent $_
            Write-Debug ("Read dotfile: {0}" -f $_)
            $C
        }

        $Dotenv_Entry = $Dotenv_Contents | ConvertFrom-Dotenv -AsEnvEntry

        if ($AsEnvEntry) {
            $Dotenv_Entry
        }
        else {
            $Dotenv_Entry | Merge-EnvEntryInternal -InitialEnv $InitialEnv -AllowClobber:$AllowClobber
        }
    }
}
