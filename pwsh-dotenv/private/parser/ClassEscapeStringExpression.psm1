using module ./ClassEvaluateContext.psm1
using module ./ClassExpression.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class EscapeStringExpression : Expression {
    [string]$value
    EscapeStringExpression([string]$value) {
        $this.value = $value
    }
    [string]Evaluate([EvaluateContext]$context) {
        $val = ""
        switch ($this.value) {
            '\' {
                $val = '\'
            }
            '\$' {
                $val = '$'
            }
        }
        if ("" -eq $val) {
            if ($this.value.StartsWith('\')) {
                $val = $this.value.Substring(1)
            }
            else {
                $val = $this.value
            }
        }
        Write-Debug -Message "$($this.GetType()): ${this} => ${val}"
        return $val
    }
    [string]ToString() {
        return $this.value
    }
}
