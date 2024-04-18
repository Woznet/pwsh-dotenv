using module ./ClassEvaluateContext.psm1
using module ./ClassExpression.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class StringLiteralExpression : Expression {
    [string]$Value
    StringLiteralExpression([string]$Value) {
        $this.Value = $Value
    }
    [string]Evaluate([EvaluateContext]$Context) {
        return $this.Value
    }
}
