#requires -Version 5
Set-StrictMode -Version Latest

function New-HashTableInternal{
    [CmdletBinding()]
    [OutputType([System.Collections.IDictionary])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Scope='Function')]
    param()
    [System.Collections.Specialized.OrderedDictionary]::new($script:StringComparer)
}
