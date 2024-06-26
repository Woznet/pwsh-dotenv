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
                C='\'
                D="2"
                E="3"
            }) -Because "<$in>"

        }
    }

    Describe "ConvertFrom-Dotenv issue #3" {

        It "Single Quotation Escape Handling" {


            $in = @'
A='\"'
B='\$'
C='\''
D='\\'
E='\n'
F='\r'
G='\t'
H=sample 
'@

            $r = $in | ConvertFrom-Dotenv -InitialEnv (@{})
            $r | Should -MatchHashtable (@{
                A='\"'
                B='\$'
                C=''''
                D='\'
                E='\n'
                F='\r'
                G='\t'
                H='sample'
            }) -Because "<$in>"

        }
    }

    Describe "ConvertFrom-Dotenv issue #4" {

        It "Empty Value Handling in pwsh-dotenv Module" {


            $in = @'
FOO=

BAR=456
'@

            $r = $in | ConvertFrom-Dotenv -InitialEnv (@{})
            $r | Should -MatchHashtable (@{
                FOO=''
                BAR='456'
            }) -Because "<$in>"

        }
    }

}



