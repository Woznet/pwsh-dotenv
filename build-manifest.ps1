$ErrorActionPreference = 'Stop'

$ModuleVersion = '1.0.4'

try {
    $Module_Root = [System.IO.Path]::Combine($PSScriptRoot, 'pwsh-dotenv')
    $Manifest_Path = [System.IO.Path]::Combine($Module_Root, 'pwsh-dotenv.psd1')

    $Export_Func = Get-ChildItem -Path ([System.IO.Path]::Combine($Module_Root, 'public')) -Recurse -Filter '*.ps1' -File | ForEach-Object {
        $_.BaseName
    }

    $Export_Alias = Get-ChildItem -Path ([System.IO.Path]::Combine($Module_Root, 'public')) -Recurse -Filter '*.ps1' -File | ForEach-Object {
        $AST = [System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$null)

        #parse out functions using the AST to get function alias
        $Functions = $AST.FindAll({ param($Ast) $Ast -is [System.Management.Automation.Language.FunctionDefinitionAST] }, $true)
        if ($Functions.Count -gt 0) {
            foreach ($F in $Functions) {
                $AliasAST = $F.FindAll({
                        param($Ast)
                        $Ast -is [System.Management.Automation.Language.AttributeAST] -and
                        $Ast.TypeName.Name -eq 'Alias' -and
                        $Ast.Parent -is [System.Management.Automation.Language.ParamBlockAST]
                    },
                    $true
                )
                if ($AliasAST.PositionalArguments) {
                    $AliasAST.PositionalArguments.Value
                }
            }
        }
    }

    $P = @{
        Path              = $Manifest_Path
        RootModule        = 'pwsh-dotenv.psm1'
        FunctionsToExport = $Export_Func
        AliasesToExport   = $Export_Alias
        ModuleVersion     = $ModuleVersion
    }

    Update-PSModuleManifest @P
}
catch {
    [System.Management.Automation.ErrorRecord]$e = $_
    [PSCustomObject]@{
        Type      = $e.Exception.GetType().FullName
        Exception = $e.Exception.Message
        Reason    = $e.CategoryInfo.Reason
        Target    = $e.CategoryInfo.TargetName
        Script    = $e.InvocationInfo.ScriptName
        Message   = $e.InvocationInfo.PositionMessage
    }
    throw $_
}
