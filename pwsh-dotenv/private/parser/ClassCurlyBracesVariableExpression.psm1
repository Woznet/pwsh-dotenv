using module ./ClassEvaluateContext.psm1
using module ./ClassExpression.psm1
using module ./EnumParameterExpansionOpTypes.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class CurlyBracesVariableExpression : Expression {
    [Expression]$Parameter
    [Expression]$Word
    [ParameterExpansionOpTypes]$Op
    [string]$Source
    CurlyBracesVariableExpression([Expression]$Parameter, [Expression]$Word, [ParameterExpansionOpTypes]$Op, [string]$Source) {
        $this.Parameter = $Parameter
        $this.Word = $Word
        $this.Op = $Op
        $this.Source = $Source
    }
    [string]Evaluate([EvaluateContext]$Context) {
        $Val = ''
        switch ($this.Op) {
            NOP {
                # NOP
            }
            BASIC_FORM {
                $Val = $this.EvaluateBasicForm($Context)
            }
            PARAMETER_IS_UNSET_OR_NULL {
                $Val = $this.EvaluateParameterIsUnsetOrNull($Context)
            }
        }
        Write-Debug -Message "$($this.GetType())($($this.Op)): $($this.Source) => ${Val}"
        return $Val
    }

    [string]ToString() {
        return $this.variable
    }

    hidden [string]EvaluateBasicForm([EvaluateContext]$Context) {
        $Val = & {
            $DebugPreference = '';
            if ($null -eq $this.Parameter) {
                return ''
            }
            else {
                return $this.Parameter.Evaluate($Context)
            }
        }
        return $Val
    }

    hidden [string]EvaluateParameterIsUnsetOrNull([EvaluateContext]$Context) {
        $Val = & {
            $DebugPreference = '';
            if ($null -eq $this.Parameter) {
                return ''
            }
            else {
                return $this.Parameter.Evaluate($Context)
            }
        }
        if ($Val -eq '') {
            if ($null -ne $this.Word) {
                $Val = $this.Word.Evaluate($Context)
            }
        }
        return $Val
    }
}

