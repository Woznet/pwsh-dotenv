using module ./ClassEValuateContext.psm1
using module ./ClassExpression.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class EscapeStringExpression : Expression {
    [string]$Value
    EscapeStringExpression([string]$Value) {
        $this.Value = $Value
    }
    [string]EValuate([EValuateContext]$Context) {
        $Val = ''
        switch -CaseSensitive ($this.Value) {
            '\t' {
                $Val = "`t"
            }
            '\r' {
                $Val = "`r"
            }
            '\n' {
                $Val = "`n"
            }
            '\$' {
                $Val = '$'
            }
            '\\' {
                $Val = '\'
            }
            '\"' {
                $Val = '"'
            }
            '\''' {
                $Val = ''''
            }
        }
        if ('' -eq $Val) {
            Write-Warning -Message ('unsupported escape ' + $this.Value)
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
        Write-Debug -Message "$($this.GetType()): ${this} => ${Val}"
        return $Val
    }
    [string]ToString() {
        return $this.Value
    }
}
