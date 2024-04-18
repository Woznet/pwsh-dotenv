using module ./ClassEvaluateContext.psm1
using module ./ClassExpression.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class SimpleVariableExpression : Expression {
    [string]$Variable_Name
    [string]$Source
    SimpleVariableExpression([string]$Variable_Name, [string]$Source) {
        $this.Variable_Name = $Variable_Name
        $this.Source = $Source
    }
    [string]Evaluate([EvaluateContext]$Context) {
        if ('' -eq $this.Variable_Name) {
            $Val = ''
        }
        else {
            $Val = $Context.GetVariable($this.Variable_Name)
        }
        Write-Debug -Message ('{0}: {1} => {2}' -f $this.GetType(), $this, $Val)
        return $Val
    }
    [string]ToString() {
        return $this.Source
    }
}

