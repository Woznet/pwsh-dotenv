using module ./ClassEvaluateContext.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class Expression {
    [string]Evaluate([EvaluateContext]$Context) {
        throw('Not Implement')
    }
}
