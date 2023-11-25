#requires -Version 5
Set-StrictMode -Version Latest

function Get-QuotedValueInternal {
    [CmdletBinding()]
    [OutputType([Object[]])]
    Param (
        [string]$InputObject,
        [string]$Quote
    )

    $reg_quote = [regex]::Escape($Quote)

    if ($InputObject -notmatch "${script:REG_START}${reg_quote}(?<value>(?:\\${reg_quote}|[^${reg_quote}])*)${reg_quote}${script:REG_SPACE}*(?:#[^\r\n]+)?${script:REG_END}?") {
        # broken string
        $first, $tail = Split-LineInternal $tail
        Write-Error "broken quoted value string ${first}" -Category ParserError
        return [EnvEntry]::new("", $false), $tail;
    }
    $value = $Matches["value"]
    $tail = $InputObject.Substring($Matches[0].Length)

    if ('"' -eq $Quote) {
        $value = Expand-EscapesInternal $value
    }

    $env_entry = [EnvEntry]::new($value, ('"' -eq $Quote))

    return $env_entry, $tail;

}
