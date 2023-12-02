#Requires -Modules @{ ModuleName="Pester"; ModuleVersion="5.0" }

. "$PSScriptRoot/../../tests/common/init.ps1"


BeforeDiscovery {
    Import-Module "$TestRoot/common/Assertions.psm1" -DisableNameChecking
}

InModuleScope "pwsh-dotenv" {

    . "$PSScriptRoot/../../tests/common/funcitons.ps1"

    BeforeAll {
        Push-Location $PSScriptRoot
    }
    AfterAll {
        Pop-Location
    }

    Describe "Readme Example" {

        BeforeEach {
            $EnvTestPrefix = "z_unit_test_pwsh_dotenv_4329f2cc_7b2e_4999_a0ef_a0b6c614455e_"
        }

        AfterEach {
            Remove-Item "Env:\${EnvTestPrefix}*"
        }

        It "Example .env File" {

            Set-Location "$PSScriptRoot/ReadmeExample/example001"

            $expected = New-Object System.Collections.Specialized.OrderedDictionary ($script:StringComparer)
            $expected["ABC"] = "123"
            $expected["DEF"] = "456"
            $expected["GHI"] = "First line`nSecond line`nThird line`n"
            $expected["J"]   = "123"
            $expected["K"]   = "456"
            $expected["L"]   = "${env:PWD}"
            $expected["M"]   = "${env:PWD}"
            $expected["N"]   = "`$PWD"
            $expected["O"]   = "`""
            $expected["P"]   = "`$"
            $expected["Q"]   = "'"
            $expected["R"]   = "\"
            $expected["S"]   = "`n"
            $expected["T"]   = "`r"
            $expected["U"]   = "`t"
            $expected["SQ"]  = "'"
            $expected["SR"]  = "\"
            $expected["V"]   = "${env:PWD}"
            $expected["W"]   = "${env:PWD}"
            $expected["X"]   = "default_value"
            $expected["Y"]   = "${env:PWD}/bin"
            $expected["Z"]   = "default_value"

            $expected.Keys | ForEach-Object{
                $name = $_
                (Test-Path "Env:\${name}") | Should -BeFalse
            }

            Import-Dotenv

            $expected.Keys | ForEach-Object{
                $name = $_
                (Get-Content "Env:\${name}") | Should -Be ($expected[$name])
            }

        }

    }

}



