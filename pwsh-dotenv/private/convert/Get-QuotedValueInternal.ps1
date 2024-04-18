#requires -Version 5
Set-StrictMode -Version Latest

function Get-QuotedValueInternal {
    [CmdletBinding()]
    [OutputType([Object[]])]
    param(
        [string]$InputObject,
        [string]$Quote
    )

    $Reg_Quote = [regex]::Escape($Quote)

    $Value_pattern = "${script:REG_START}${Reg_Quote}(?<value>(?:\\\\|\\${Reg_Quote}|[^${Reg_Quote}])*)${Reg_Quote}${script:REG_SPACE}*(?:#[^\r\n]+)?${script:REG_END}?"
    if ($InputObject -notmatch $Value_pattern) {
        # broken string
        $First, $Tail = Split-LineInternal $Tail
        Write-Error ('broken quoted value string {0}' -f $First) -Category ParserError
        return [EnvEntry]::new('', [EnumQuoteTypes]::UNQUOTED), $Tail;
    }
    $Value = $Matches['value']
    $Tail = $InputObject.Substring($Matches[0].Length)

    if (('"' -eq $Quote)) {
        $Quote_Type = [EnumQuoteTypes]::DOUBLE_QUOTED
    }
    elseif (("'" -eq $Quote)) {
        $Quote_Type = [EnumQuoteTypes]::SINGLE_QUOTED
    }
    else {
        $Quote_Type = [EnumQuoteTypes]::UNQUOTED
    }
    $Env_Entry = [EnvEntry]::new($Value, $Quote_Type)

    return $Env_Entry, $Tail;
}
