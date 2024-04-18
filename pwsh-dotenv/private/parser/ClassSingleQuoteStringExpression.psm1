using module ./ClassEvaluateContext.psm1
using module ./ClassExpression.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class SingleQuoteStringExpression : Expression {
    [string]$Value
    SingleQuoteStringExpression([string]$Value) {
        $this.Value = $Value
    }
    [string]Evaluate([EvaluateContext]$Context) {
        return [regex]::Replace($this.Value, "\\\\|\\'", {
                Param([System.Text.RegularExpressions.Match]$Match)
                $Val = ''
                switch -CaseSensitive ($Match.Value) {
                    '\\' {
                        $Val = '\'
                    }
                    "\'" {
                        $Val = "'"
                    }
                }
                if ('' -eq $Val) {
                    Write-Warning -Message ('unsupported escape {0}' -f $this.Value)
                    if ('\' -eq $this.Value) {
                        $Val = '\'
                    }
                    elseif ($this.Value.StartsWith('\')) {
                        $Val = $this.Value.Substring(1)
                    }
                    else {
                        $Val = $this.Value
                    }
                }
                return $Val
            })
    }
    [string]ToString() {
        return $this.Value
    }
}
