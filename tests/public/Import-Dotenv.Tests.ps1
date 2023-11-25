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

    Describe "Import-Dotenv" {

        BeforeEach {
            $EnvTestPrefix = "z_unit_test_pwsh_dotenv_4329f2cc_7b2e_4999_a0ef_a0b6c614455e_"
        }

        AfterEach {
            Remove-Item "Env:\${EnvTestPrefix}*"
        }

        It "Path" {
            Set-Location "$PSScriptRoot/Import-Dotenv/001-01"

            (Test-Path "Env:\${EnvTestPrefix}test1") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}test2") | Should -BeFalse

            Import-Dotenv

            (Get-Content "Env:\${EnvTestPrefix}test1") | Should -Be "ABC"
            (Get-Content "Env:\${EnvTestPrefix}test2") | Should -Be "123"

        }

        It "Path" {
            Set-Location "$PSScriptRoot/Import-Dotenv/001-02"

            (Test-Path "Env:\${EnvTestPrefix}PWD") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}PATH") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST1") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST3") | Should -BeFalse

            Import-Dotenv -Path @("test1.env", "test2.env")

            (Get-Content "Env:\${EnvTestPrefix}PWD") | Should -Be "${env:PWD}/TestPWD"
            (Get-Content "Env:\${EnvTestPrefix}PATH") | Should -Be "${env:PWD}/TestPWD"
            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "123"
            (Get-Content "Env:\${EnvTestPrefix}TEST2") | Should -Be "${env:PWD}/TestPWD"
            (Get-Content "Env:\${EnvTestPrefix}TEST3") | Should -Be "${env:PWD}/ABC"

        }

        It "AllowClobber:`$false" {
            Set-Location "$PSScriptRoot/Import-Dotenv/002"

            Set-Content  -LiteralPath "Env:\${EnvTestPrefix}TEST1" -Value "ABC"

            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "ABC"
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse

            Import-Dotenv -AllowClobber:$false

            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "ABC"
            (Get-Content "Env:\${EnvTestPrefix}TEST2") | Should -Be "123"

        }

        It "AllowClobber:`$true" {
            Set-Location "$PSScriptRoot/Import-Dotenv/002"

            Set-Content  -LiteralPath "Env:\${EnvTestPrefix}TEST1" -Value "ABC"

            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "ABC"
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse

            Import-Dotenv -AllowClobber:$true

            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "DEF"
            (Get-Content "Env:\${EnvTestPrefix}TEST2") | Should -Be "123"

        }

        It "Encoding" {
            Set-Location "$PSScriptRoot/Import-Dotenv/003"

            (Test-Path "Env:\${EnvTestPrefix}TEST") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}test") | Should -BeFalse

            Import-Dotenv -Encoding ([System.Text.Encoding]::GetEncoding("sjis")) -Path "sjis.env"

            (Get-Content "Env:\${EnvTestPrefix}TEST") | Should -Be "123"
            (Get-Content "Env:\${EnvTestPrefix}test") | Should -Be "亜"

        }

        It "SkipReadErrorCheck" {
            Set-Location "$PSScriptRoot/Import-Dotenv/004"

            (Test-Path "Env:\${EnvTestPrefix}TEST1") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse

            { Import-Dotenv } | Should -Throw

            (Test-Path "Env:\${EnvTestPrefix}TEST1") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse

            { Import-Dotenv -Path @("test.env", "notfound.env") -SkipReadErrorCheck:$false } | Should -Throw

            (Test-Path "Env:\${EnvTestPrefix}TEST1") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse

            Import-Dotenv -Path @("notfound.env", "test.env") -SkipReadErrorCheck:$true

            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "ABC"
            (Get-Content "Env:\${EnvTestPrefix}TEST2") | Should -Be "123"

        }


        It "PassThru" {
            Set-Location "$PSScriptRoot/Import-Dotenv/005"

            (Test-Path "Env:\${EnvTestPrefix}TEST1") | Should -BeFalse
            (Test-Path "Env:\${EnvTestPrefix}TEST2") | Should -BeFalse

            $r1 = Import-Dotenv -PassThru

            (Get-Content "Env:\${EnvTestPrefix}TEST1") | Should -Be "ABC"
            (Get-Content "Env:\${EnvTestPrefix}TEST2") | Should -Be "123"

            $r1 | Should -MatchHashtable (@{
                    "${EnvTestPrefix}TEST1" = "ABC";
                    "${EnvTestPrefix}TEST2" = "123";
                })

        }


    }

}



