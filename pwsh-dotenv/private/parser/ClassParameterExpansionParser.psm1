using module ./EnumParameterExpansionOpTypes.psm1
using module ./ClassSimpleVariableExpression.psm1
using module ./ClassParameterExpansion.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class ParameterExpansionParser {

    [regex]$PREFIX_PATTERN = [regex]'\G(?:[\\$}]|[^\\$}]+)'

    [string]$Str
    [ParameterExpansion]$Expansion

    ParameterExpansionParser([string]$Str) {
        $this.Str = $Str
        $this.Expansion = [ParameterExpansion]::new()
    }

    [ParameterExpansion]Parse() {
        [void]$this._Parse(0, 0)
        return $this.Expansion
    }

    hidden [int]_Parse([int]$Parser_Start_Index, [int] $Nested_Levels) {
        $M = $this.NextMatch($Parser_Start_Index)
        for (; ; ) {
            if (($null -eq $M) -or (-not $M.Success)) {
                if (0 -lt $Nested_Levels) {
                    # } closing curly brace not found
                    return -1
                }
                break
            }

            if ($M.Value.StartsWith('}') -and (0 -lt $Nested_Levels) ) {
                # } closing curly brace
                return ($M.Index + $M.Length)
            }
            if ($M.Value.StartsWith('\')) {
                # escape
                if (($M.Index + 1) -lt $this.Str.Length) {
                    $this.Expansion.AddEscapeString(($this.Str[$M.Index..($M.Index + 1)] -join ''))
                    $M = $this.NextMatch($M.Index + 2)
                }
                else {
                    $this.Expansion.AddEscapeString(($this.Str[$M.Index..($M.Index)] -join ''))
                    $M = $this.NextMatch($M.Index + 1)
                }
            }
            elseif ($M.Value.StartsWith('$')) {
                # variable
                $Next_Index = $this.ParseParameterExpansion($M.Index, $Nested_Levels)
                $M = $this.NextMatch($Next_Index)
            }
            else {
                $this.Expansion.AddStringLiteral($M.Value)
                $M = $M.NextMatch()
            }
        }
        return $this.Str.Length
    }

    hidden [System.Text.RegularExpressions.Match]NextMatch([int]$Index) {
        if ($Index -le $this.Str.Length) {
            return $this.PREFIX_PATTERN.Match($this.Str, $Index)
        }
        return $null
    }

    hidden [int]ParseParameterExpansion([int]$Start_Index, [int] $Nested_Levels) {
        if ($this.Str.IndexOf('${', $Start_Index, 2) -eq $Start_Index) {
            # ${variable} format
            return $this.ParseCurlyBracesVariableExpansion($Start_Index, $Nested_Levels)
        }
        $M = ([regex]'\G\$(?<Variable_Name>[a-zA-Z_][a-zA-Z0-9_]*)').Match($this.Str, $Start_Index)
        if ($M.Success) {
            # $Variable format
            $this.Expansion.AddSimpleVariable($M.Groups['Variable_Name'].Value, $M.Value)
            return ($M.Index + $M.Length)
        }
        $this.Expansion.AddStringLiteral($this.Str[$Start_Index])
        return $Start_Index + 1
    }

    hidden [int]ParseCurlyBracesVariableExpansion([int]$Start_Index, [int] $Nested_Levels) {
        $M = ([regex]'\G\${(?<Variable_Name>[a-zA-Z_][a-zA-Z0-9_]*)[:}]').Match($this.Str, $Start_Index)
        if (-not $M.Success) {
            Write-Warning -Message "$($this.GetType()): bad substitution: $($this.Str.Substring($Start_Index))"
            return $this.Str.Length
        }

        $Variable_Name = $M.Groups['Variable_Name'].Value
        if ($M.Value.EndsWith('}')) {
            # ${variable} format
            $this.Expansion.AddCurlyBracesVariable([SimpleVariableExpression]::new($Variable_Name, $M.Value), $null, [ParameterExpansionOpTypes]::BASIC_FORM, $M.Value)
            return ($M.Index + $M.Length)
        }
        if ($M.Value.EndsWith(':')) {
            # ${variable: format
            if ('-' -eq $this.Str[($M.Index + $M.Length)]) {
                # ${variable:- format

                $P = [ParameterExpansionParser]::new($this.Str)
                $Next_Index = $P._Parse($Start_Index + $M.Length + 1, $Nested_Levels + 1)
                if ($Next_Index -lt 0) {
                    Write-Warning -Message "$($this.GetType()): bad substitution: $($this.Str.Substring($Start_Index))"
                    return $this.Str.Length
                }
                $Word = $P.Expansion
                $Source = $this.Str.Substring($Start_Index, $Next_Index - $Start_Index)
                $Param = [SimpleVariableExpression]::new($Variable_Name, $Source);
                $this.Expansion.AddCurlyBracesVariable($Param, $Word, [ParameterExpansionOpTypes]::PARAMETER_IS_UNSET_OR_NULL, $Source)
                return $Next_Index
            }
        }
        Write-Warning -Message "$($this.GetType()): bad substitution: $($this.Str.Substring($Start_Index))"
        return $this.Str.Length
    }
}
