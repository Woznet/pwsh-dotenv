#requires -Version 5
Set-StrictMode -Version Latest

function Import-Dotenv {
    <#
    .SYNOPSIS
        Reads a dotenv-formatted file and returns it in Hashtable format.
    .DESCRIPTION
        This cmdlet converts a dotenv(.env) formatted string into either a Hashtable or a EnvEntry array.
    .EXAMPLE
        PS C:\> Import-Dotenv

        .EXAMPLE
        PS C:\> Import-Dotenv '.test.env' -PassThru

        ----                           -----
        ABC                            1
        DEF                            3

    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('dotenv')]
    [OutputType([hashtable], ParameterSetName = 'Hashtable')]
    param(
        # Specifies a Path Name of the .env.
        [Parameter(Position = 0 , ValueFromPipeline)]
        [ValidateScript({
            if(-not ($_ | Test-Path -PathType Leaf) ){
              throw 'File does not exist'
            }
            return $true
        })]
        [string[]]$Path = '.env',
        # Enables the behavior to OVERRIDE environment variables.
        [Parameter()]
        [switch]$AllowClobber,
        # Specifies the encoding type for .env. The default value is UTF-8.
        [Parameter()]
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8,
        # Ignore errors if the file does not exist.
        [Parameter()]
        [switch]$SkipReadErrorCheck,
        # Returns an hashtable representing the imported dotenv. By default, this cmdlet doesn't generate any output.
        [Parameter(ParameterSetName = 'Hashtable')]
        [switch]$PassThru
    )
    Begin {
        $Dotenv_Files = [System.Collections.Generic.List[string]]::new()
    }
    Process {
        foreach($File in $Path) {
            $Dotenv_Files.Add($File)
        }
    }
    End {

        $Envs = Read-Dotenv -Path $Dotenv_Files -AllowClobber:$AllowClobber -Encoding $Encoding -SkipReadErrorCheck:$SkipReadErrorCheck

        foreach ($Name in $Envs.Keys) {
            $Env_Path = Join-Path -Path "${script:EnvDriveName}:" -ChildPath $Name
            $Value = $Envs[$Name]
            if ($PSCmdlet.ShouldProcess("Set ${Env_Path}=${Value}")) {
                Set-Content -LiteralPath $Env_Path -Value $Value -Confirm:$false
                Write-Verbose "Set ${Env_Path}=${Value}"
            }
        }

        if ($PassThru) {
            $Envs
        }
    }
}
