using module ./parser/ClassParameterExpansionParser.psm1
using module ./parser/ClassEvaluateContext.psm1

#requires -Version 5
Set-StrictMode -Version Latest

class EnvEntry {

    [string]$Name = ""
    [string]$Value = ""
    [bool]$Expand = $false

    EnvEntry([string]$Value, [bool]$Expand) {
        $this.Value = $Value
        $this.Expand = $Expand
    }

    [string]GetValue([scriptblock]$env_getter) {
        if ((-not $this.Expand) -or (-not $this.Value.Contains('$'))) {
            return $this.Value
        }

        $parser = [ParameterExpansionParser]::new($this.Value)
        $expansion = $parser.Parse()
        $valuate_context = [EvaluateContext]::new({
                param($variable_name)
                return (& $env_getter ($variable_name))
            })

        return $expansion.Evaluate($valuate_context)

    }

    [string]ToString() {
        return $this.Name + "=" + $this.Value
    }

}
