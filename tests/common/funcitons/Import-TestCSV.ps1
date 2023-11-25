function Import-TestCSV {
    [CmdletBinding()]
    param (
        [string]$Path
    )
    begin {
        function decodeJSON {
            param ([string]$text)
            [regex]::Replace($text, '@json_decode\(([^)]+)\)', {
                    param($match)
                    return ($match.Groups[1].Value | ConvertFrom-Json)
                })
        }
    }
    process {
        Import-Csv $Path | ForEach-Object {
            $r = $_
            $names = @($_.PSObject.Properties | ForEach-Object { $_.Name })

            if (@($names | Where-Object { "" -ne $r.$_ }).Count -lt 1) {
                return
            }

            if (($names -contains "TEST") -and ($r.TEST -eq "skip")) {
                return
            }

            $org_input = $r.INPUT

            $names | ForEach-Object {
                $r.$_ = decodeJSON ($r.$_)
            }

            $expect_value = New-Object System.Collections.Hashtable
            $names | Where-Object { $_ -match "EXPECT_NAME\d*" } | ForEach-Object {
                $nm = $_
                $name = $r.$nm
                if ("" -eq $name) {
                    return
                }

                $val = $nm -replace "EXPECT_NAME", "EXPECT_VALUE"
                $value = $r.$val

                $expect_value[$name] = $value
            }

            $r | Add-Member -MemberType NoteProperty -Name "ORG_INPUT" -Value $org_input
            $r | Add-Member -MemberType NoteProperty -Name "EXPECT" -Value $expect_value

            if ($names -notcontains "INIT_ENV") {
                $r | Add-Member -MemberType NoteProperty -Name "INIT_ENV" -Value @{}
            }
            elseif ("" -eq $r.INIT_ENV.Trim()) {
                $r.INIT_ENV = @{}
            }else{
                $r.INIT_ENV = $r.INIT_ENV | ConvertFrom-Json -AsHashtable
            }

            return $r
        }
    }

    end {

    }
}
