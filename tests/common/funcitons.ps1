
(Get-ChildItem -Path "$PSScriptRoot/funcitons/*.ps1" -Recurse -ErrorAction SilentlyContinue ) | Sort-Object DirectoryName,Name | ForEach-Object {
    . $_.Fullname
}

function getclosestdir($Path, $DirName) {
    $p = $path
    while($true){
        $p = Split-Path $p -Parent

        if($p -eq ""){
            return
        }

        if((Split-Path $p -Leaf) -eq $DirName){
            $p
            return
        }
    }
}

function joinpaths() {
    $base = ""
    foreach ($p in $args) {
        if($base -eq ""){
            $base = $p
        }else{
            $base = Join-Path $base $p
        }
    }
    $base
}

function importcsv ($path) {
    Import-Csv -Path $path
}

function importcsv2hashtable ($path) {
    Import-Csv -Path $path | ForEach-Object {
        $ht = @{}
        $_.psobject.properties | ForEach-Object { $ht[$_.Name] = $_.Value }
        $ht
    }
}
