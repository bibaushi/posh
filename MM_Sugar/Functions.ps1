function ..  { cd .. }
function ... { cd ..\.. }
function e { exit }
function q { exit }

function Start-Powershell { start powershell }
Set-Alias posh Start-Powershell

<# .SYNOPSIS
    Test for administration privileges
#>
function Test-Admin() {
    $usercontext = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $usercontext.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

function halt { shutdown -t 0 }
function hiber { shutdown -t 0 -h }
function reboot { shutdown -t 0 -r }

#function expand() {
    #[CmdletBinding()]
    #param ( [parameter(ValueFromPipeline = $true)] [string] $s)
    #$ExecutionContext.InvokeCommand.ExpandString($s)
#}

<# .SYNOPSIS
    Expands powershell string.
   .EXAMPLE
    gc template.ps1 | expand
#>
function expand() {
    [CmdletBinding()]
    param ( [parameter(ValueFromPipeline = $true)] [string] $str)

    "@`"`n$str`n`"@" | iex
}
<# .SYNOPSIS
    Edit multiple files in $Env:EDITOR
   .EXAMPLE
    dir ..\*.txt | ed  .\my_file.txt

    Edit all text files from parent directory along with my_file.txt from current dir.
#>
function ed () { $f = $input + $args | gi | % { $_.fullname };  iex "$Env:EDITOR $f" }

<# .SYNOPSIS
    Edit $PROFILE using $Env:EDITOR
#>
function edp { ed $PROFILE }

<# .SYNOPSIS
    Get current time in format ISO8601 yyyy-MM-ddTHH-mm-ss
#>
function now([switch]$fs) {[DateTime]::UtcNow.ToString("s").Replace(':','-')}

<# .SYNOPSIS
    Execute script in given directory or given files directory
#>
function in ($dir, $script) {
    if (Test-Path $dir -PathType Leaf) { $dir = Split-Path $dir -Parent }
    pushd $dir; & $script; popd
}

<# .SYNOPSIS
    Set current and working directory to the same one.
#>
function Set-WorkingDir([string] $Dir=$pwd) { cd $Dir; [IO.Directory]::SetCurrentDirectory($Dir) }

<# .SYNOPSIS
    List Powershell command parameters
#>
function params( $cmd ) {
    (gcm $cmd).ParameterSets.Parameters | select `
        Name,
        @{Name="Position";    Expression={if($_.Position -lt 0) {"-"} else {$_.Position}}},
        @{Name="Mandatory";   Expression={if ($_.IsMandatory) { "Yes" } else {""}}},
        @{Name="Type";        Expression={$_.ParameterType.Name}},
        "Aliases"
}

<# .SYNOPSIS
    Returns all scheduled tasks under the username Path in Task Scheduler
#>
function tasks() { Get-ScheduledTask -TaskPath *$Env:USERNAME* }
function reload( $module ) { remove-module $module -ea ignore; import-module $module }
function groups { [System.Security.Principal.WindowsIdentity]::GetCurrent().Groups | % {$_.Translate([Security.Principal.NTAccount])} | sort }
