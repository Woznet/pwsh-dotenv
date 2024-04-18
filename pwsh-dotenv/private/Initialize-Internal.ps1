#requires -Version 5
Set-StrictMode -Version Latest

function Initialize-Internal() {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidAssignmentToAutomaticVariable', '', Scope = 'Function')]
    param()

    if (-not (Test-Path Microsoft.PowerShell.Core\Variable::IsCoreCLR)) {
        $IsCoreCLR = $false;
    }
    if (-not (Test-Path Microsoft.PowerShell.Core\Variable::IsWindows)) {
        $IsWindows = $true;
    }

    Set-Variable -Scope script -Option None -Name EnvDriveName -Value 'Env'
    Set-Variable -Scope script -Option None -Name IsCaseSensitive -Value ($IsCoreCLR -and (-not $IsWindows))
    Set-Variable -Scope script -Option None -Name REG_START -Value ('(?:\A|^)')
    Set-Variable -Scope script -Option None -Name REG_END -Value ('(?:\z|[\r\n]+)')
    Set-Variable -Scope script -Option None -Name REG_SPACE -Value ('(?:[ \t\r\n\f\v])')
    Set-Variable -Scope script -Option None -Name REG_KEY -Value ('[a-zA-Z_][a-zA-Z0-9_]*')

    if ($IsCaseSensitive) {
        Set-Variable -Scope script -Option None -Name StringComparer -Value ([StringComparer]::Ordinal)
    }
    else {
        Set-Variable -Scope script -Option None -Name StringComparer -Value ([StringComparer]::OrdinalIgnoreCase)
    }
}
