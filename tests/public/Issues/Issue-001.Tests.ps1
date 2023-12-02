#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0" }

. "$PSScriptRoot/../../../tests/common/init.ps1"


BeforeDiscovery {
    Import-Module "$TestRoot/common/Assertions.psm1" -DisableNameChecking
}

InModuleScope "pwsh-dotenv" {

    . "$PSScriptRoot/../../../tests/common/funcitons.ps1"

    BeforeAll {
        Push-Location $PSScriptRoot
    }
    AfterAll {
        Pop-Location
    }

    Describe "ConvertFrom-Dotenv issue #1" {

        It "empty line" {

            $in = @(
                "#"
                ""
                "TEST=1"
            ) -join "`n"

            $convertwarning = New-Object System.Collections.ArrayList

            $r = $in | ConvertFrom-Dotenv -InitialEnv (@{}) -WarningVariable "+convertwarning" 3> $null
            $r | Should -MatchHashtable (@{TEST = "1" })

            $convertwarning | Should -BeNullOrEmpty

        }
    }

    Describe "ConvertFrom-Dotenv issue #2" {

        It "broken Backslash escaping" {


            $in = @'
A="\\"
B="1"
C='\\'
D='2'
E=3
'@.Trim()

            $r = $in | ConvertFrom-Dotenv -InitialEnv (@{})
            $r | Should -MatchHashtable (@{
                A='\'
                B="1"
                C='\\'
                D="2"
                E="3"
            }) -Because "<$in>"

        }
    }

}



