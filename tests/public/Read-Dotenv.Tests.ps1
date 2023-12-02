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

    Describe "Read-Dotenv" {

        BeforeEach {
            $EnvTestPrefix = "z_unit_test_pwsh_dotenv_4329f2cc_7b2e_4999_a0ef_a0b6c614455e_"
            $BasicEnvName = "${EnvTestPrefix}Test"
        }

        AfterEach {
            Remove-Item "Env:\${EnvTestPrefix}*"
        }

        It "Path" {
            Set-Location "$PSScriptRoot/Read-Dotenv/001-01"

            $r = Read-Dotenv -InitialEnv (@{})
            $r | Should -MatchHashtable (@{TEST_KEY = "ABC" })

        }

        It "Path" {
            Set-Location "$PSScriptRoot/Read-Dotenv/001-02"

            $r1 = Read-Dotenv -InitialEnv (@{}) -Path ("test1.env", "test2.env")
            $r1 | Should -MatchHashtable (@{TEST_KEY1 = "ABC1"; TEST_KEY2 = "ABC2" })

            $r2 = ("test1.env", "test2.env") | Read-Dotenv -InitialEnv (@{})
            $r2 | Should -MatchHashtable (@{TEST_KEY1 = "ABC1"; TEST_KEY2 = "ABC2" })

        }

        It "Path" {
            Set-Location "$PSScriptRoot/Read-Dotenv/002-01"

            { Read-Dotenv } | Should -Throw
            { Read-Dotenv -Path "test.env" } | Should -Not -Throw

        }

        It "SkipReadErrorCheck" {
            Set-Location "$PSScriptRoot/Read-Dotenv/003-01"

            { Read-Dotenv -SkipReadErrorCheck } | Should -Not -Throw

            $r1 = Read-Dotenv -InitialEnv (@{}) -Path ("test1.env","test2.env") -SkipReadErrorCheck
            $r1 | Should -MatchHashtable (@{TEST="1"})

        }

        It "empty file" {
            Set-Location "$PSScriptRoot/Read-Dotenv/004"

            $r1 = Read-Dotenv -InitialEnv (@{})
            $r1 | Should -MatchHashtable (@{})

        }

        It "InitialEnv" {
            Set-Location "$PSScriptRoot/Read-Dotenv/005"

            Set-Content  -LiteralPath "Env:\${BasicEnvName}" -Value "ABC"

            $r1 = Read-Dotenv
            $r1 | Should -MatchHashtable (@{ABC1="ABC";ABC2=$env:PWD}) -Because "<$(Get-Content -Raw ".env")>"

            $r2 = Read-Dotenv -InitialEnv (@{$BasicEnvName=123})
            $r2 | Should -MatchHashtable (@{ABC1="123";ABC2=""}) -Because "<$(Get-Content -Raw ".env")>"

        }

        It "AllowClobber" {
            Set-Location "$PSScriptRoot/Read-Dotenv/006"

            $r1 = Read-Dotenv -InitialEnv (@{ABC1="ABC"}) -AllowClobber:$false
            $r1 | Should -MatchHashtable (@{ABC2="2"}) -Because "<$(Get-Content -Raw ".env")>"

            $r2 = Read-Dotenv -InitialEnv (@{ABC1="ABC"}) -AllowClobber:$true
            $r2 | Should -MatchHashtable (@{ABC1="1";ABC2="2"}) -Because "<$(Get-Content -Raw ".env")>"

        }

        It "Encoding" -ForEach @(
            [PSCustomObject]@{Path="utf8.env";Encoding=[System.Text.Encoding]::UTF8; }
            [PSCustomObject]@{Path="utf8_with_bom.env";Encoding=[System.Text.Encoding]::UTF8; }
            [PSCustomObject]@{Path="utf16le.env";Encoding=[System.Text.Encoding]::Unicode ; }
            [PSCustomObject]@{Path="utf16be.env";Encoding=[System.Text.Encoding]::BigEndianUnicode ; }
            [PSCustomObject]@{Path="sjis.env";Encoding=[System.Text.Encoding]::GetEncoding("shift_jis") ; }
        ) {
            Set-Location "$PSScriptRoot/Read-Dotenv/007"

            $c = $_

            $r1 = Read-Dotenv -InitialEnv (@{}) -Encoding $c.Encoding -Path $c.Path
            $r1 | Should -MatchHashtable (@{EMOJI_KEY="①";TEST=$c.Path}) -Because "<$(Get-Content -Raw $c.Path)>"

        }

        It "AsEnvEntry" {
            Set-Location "$PSScriptRoot/Read-Dotenv/008"

            $r = Read-Dotenv -AsEnvEntry
            $r | Should -MatchEnvEntry @(
                @{Name="ABC1";Value='A1';QuoteType=[EnumQuoteTypes]::UNQUOTED}
                @{Name="ABC2";Value='B2';QuoteType=[EnumQuoteTypes]::SINGLE_QUOTED}
                @{Name="ABC1";Value='${ABC1}A2';QuoteType=[EnumQuoteTypes]::DOUBLE_QUOTED}
                @{Name="ABC1";Value='${ABC1}A3';QuoteType=[EnumQuoteTypes]::SINGLE_QUOTED}
                @{Name="ABC1";Value='${ABC1}A4$ABC2';QuoteType=[EnumQuoteTypes]::UNQUOTED}
            ) -Because "<$(Get-Content -Raw ".env")>"

        }


    }

}



