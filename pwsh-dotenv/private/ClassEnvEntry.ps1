using module ./parser/ClassParameterExpansionParser.psm1
using module ./parser/ClassEvaluateContext.psm1
using module ./parser/ClassSingleQuoteStringExpression.psm1
using module ./parser/EnumQuoteTypes.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class EnvEntry {

    [string]$Name = ''
    [string]$Value = ''
    [EnumQuoteTypes]$QuoteType

    EnvEntry([string]$Value, [EnumQuoteTypes]$QuoteType) {
        $this.Value = $Value
        $this.QuoteType = $QuoteType
    }

    [string]GetValue([scriptblock]$Env_Getter) {
        if ((-not ($this.Value.Contains('$') -or $this.Value.Contains('\')))) {
            return $this.Value
        }

        if ($this.QuoteType -eq [EnumQuoteTypes]::SINGLE_QUOTED) {
            $Expansion = [SingleQuoteStringExpression]::new($this.Value)
        }
        else {
            $Parser = [ParameterExpansionParser]::new($this.Value)
            $Expansion = $Parser.Parse()
        }

        $Valuate_Context = [EvaluateContext]::new({
                param($Variable_Name)
                return (& $Env_Getter ($Variable_Name))
            })

        return $Expansion.Evaluate($Valuate_Context)
    }

    [string]ToString() {
        return ('{0}={1}' -f $this.Name, $this.Value)
    }
}
