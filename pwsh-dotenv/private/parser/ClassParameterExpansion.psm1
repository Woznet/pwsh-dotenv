using module ./ClassEvaluateContext.psm1
using module ./ClassExpression.psm1
using module ./ClassStringLiteralExpression.psm1
using module ./ClassEscapeStringExpression.psm1
using module ./ClassSimpleVariableExpression.psm1
using module ./ClassCurlyBracesVariableExpression.psm1
using module ./EnumParameterExpansionOpTypes.psm1

#requires -Version 5
Set-StrictMode -Version Latest


class ParameterExpansion: Expression {

    [System.Collections.Generic.List[Expression]]$Expressions

    ParameterExpansion() {
        $this.Expressions = [System.Collections.Generic.List[Expression]]::new()
    }

    [string]Evaluate([EvaluateContext]$Context) {
        $Buffer = [System.Text.StringBuilder]::new()
        foreach ($Expression in $this.Expressions) {
            $Buffer.Append($Expression.Evaluate($Context))
        }
        return $Buffer.ToString()
    }

    [void]AddStringLiteral([string]$Value) {
        $this.Expressions.Add([StringLiteralExpression]::new($Value))
    }
    [void]AddEscapeString([string]$Value) {
        $this.Expressions.Add([EscapeStringExpression]::new($Value))
    }
    [void]AddSimpleVariable([string]$Variable_Name, [string]$Source) {
        $this.Expressions.Add([SimpleVariableExpression]::new($Variable_Name, $Source))
    }
    [void]AddCurlyBracesVariable([Expression]$Parameter, [Expression]$Word, [ParameterExpansionOpTypes]$Op, [string]$Source) {
        $this.Expressions.Add([CurlyBracesVariableExpression]::new($Parameter, $Word, $Op, $Source))
    }
}
