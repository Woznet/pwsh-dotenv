#requires -Version 5
Set-StrictMode -Version Latest

class EvaluateContext {

    [scriptblock]$Variable_Getter

    EvaluateContext([scriptblock]$Variable_Getter) {
        $this.Variable_Getter = $Variable_Getter
    }

    [string]GetVariable([string]$Variable_Name) {
        return & $this.Variable_Getter $Variable_Name
    }
}
