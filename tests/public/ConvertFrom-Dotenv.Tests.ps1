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

    Describe "ConvertFrom-Dotenv" {

        BeforeEach {
            $EnvTestPrefix = "z_unit_test_pwsh_dotenv_4329f2cc_7b2e_4999_a0ef_a0b6c614455e_"
            $BasicEnvName = "${EnvTestPrefix}Test"
        }

        AfterEach {
            Remove-Item "Env:\${EnvTestPrefix}*"
        }

        It "Test unicode" {
            $in = @(
                "日本語キー=値"
                "EMOJI_KEY=🔑"
            ) -join "`n"
            $r = $in | ConvertFrom-Dotenv -InitialEnv (@{}) -ErrorVariable "+converterror" 2> $null
            $r | Should -MatchHashtable (@{EMOJI_KEY = "🔑" })

            $converterror.Exception.Message | Should -Be ('unexpected character "日本語キー" in variable name near ' + $in)

        }

        It "Test AllowClobber" {
            $in = @(
                "ABC1=1",
                "ABC2=2"
            ) -join "`n"
            $r1 = $in | ConvertFrom-Dotenv -InitialEnv (@{ABC1="5"}) -AllowClobber:$false
            $r1 | Should -MatchHashtable (@{ABC2="2"})

            $r2 = $in | ConvertFrom-Dotenv -InitialEnv (@{ABC1="5"}) -AllowClobber:$true
            $r2 | Should -MatchHashtable (@{ABC1="1";ABC2="2"})
        }

        It "Test InitialEnv" {

            Set-Content  -LiteralPath "Env:\${BasicEnvName}" -Value "ABC"

            $in = (@(
                "ABC1=`$${BasicEnvName}",
                "ABC2=`$PWD"
            )) -join "`n"

            $r1 = $in | ConvertFrom-Dotenv
            $r1 | Should -MatchHashtable (@{ABC1="ABC";ABC2=$env:PWD}) -Because "<$($in)>"

            $r2 = $in | ConvertFrom-Dotenv -InitialEnv (@{$BasicEnvName=123})
            $r2 | Should -MatchHashtable (@{ABC1="123";ABC2=""}) -Because "<$($in)>"

        }

        It "Test AsEnvEntry" {

            Set-Content  -LiteralPath "Env:\${BasicEnvName}" -Value "ABC"

            $in = (@(""
                "ABC1" + "=" + '$PWD';
                "ABC2" + "=" + '"$PWD"';
                "ABC3" + "=" + '''$PWD''';
                'Test001=sample1';
                'Test001="sample2"';
                'Test001=''sample3''';
            )) -join "`n"

            $r = $in | ConvertFrom-Dotenv -AsEnvEntry

            $r | Should -MatchEnvEntry @(
                @{Name="ABC1";Value='$PWD';Expand=$true}
                @{Name="ABC2";Value='$PWD';Expand=$true}
                @{Name="ABC3";Value='$PWD';Expand=$false}
                @{Name="Test001";Value='sample1';Expand=$true}
                @{Name="Test001";Value='sample2';Expand=$true}
                @{Name="Test001";Value='sample3';Expand=$false}
            ) -Because "<$($in)>"

        }

    }

    Describe "ConvertFrom-Dotenv format test" -ForEach @(
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/format/booleans.csv"; }
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/format/comments.csv"; }
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/format/env.csv"}
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/format/escape.csv"}
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/variable.csv"}
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/variable_brace.csv"}
        [PSCustomObject]@{path="$PSScriptRoot/ConvertFrom-Dotenv/format/illegal.csv"; }
    ) {

        BeforeAll {
        }
        AfterAll {
        }

        BeforeEach {
        }
        AfterEach {
        }

        It "$(Split-Path -Leaf $_.path)" -ForEach (Import-TestCSV $_.path) {
            $r = $_.INPUT | ConvertFrom-Dotenv -InitialEnv ($_.INIT_ENV) -AllowClobber
            $r | Should -MatchHashtable $_.EXPECT -Because "<$($_.ORG_INPUT)>"
        }

    }

    Describe "ConvertFrom-Dotenv illegal" {

        BeforeEach {
            $EnvTestPrefix = "z_unit_test_pwsh_dotenv_4329f2cc_7b2e_4999_a0ef_a0b6c614455e_"
            $BasicEnvName = "${EnvTestPrefix}Test"
        }

        AfterEach {
            Remove-Item "Env:\${EnvTestPrefix}*"
        }

        It "empty key" {

            $in = @(
                "TEST=1"
                "EMPTY_LINE"
            ) -join "`n"

            $r = $in | ConvertFrom-Dotenv -InitialEnv (@{}) -WarningVariable "+convertwarning" 3> $null
            $r | Should -MatchHashtable (@{TEST = "1" })

            $convertwarning.Message | Should -Be ('invalid line:EMPTY_LINE')

        }
    }

}



