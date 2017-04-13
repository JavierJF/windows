<#
    This script installs the needed dependencies for the Windows 7 Mopher
#>

Import-Module (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) 'Provisioning.psm1') -Force

$VerbosePreference = "continue"

$chocolatey = "$env:ChocolateyInstall\bin\choco.exe" -f $env:SystemDrive
$classicShellVers = "4.3.0.0"
$classicShellDir = "C:\Program Files\Classic Shell\"
$classicShellPath = "C:\Program Files\Classic Shell\ClassicStartMenu.exe"
$classicShellProcessName = "ClassicStartMenu"
$classicShellStopScript = Join-Path $(Split-Path -Parent $MyInvocation.MyCommand.Path) "ClassicShellStop.ps1"

try
{
    <# Classic-Shell installation #>
    Invoke-Command $chocolatey "install classic-shell --version $($classicShellVers) -y" "" 0
    <# Install the required script to start stop classic-shell #>
    Copy-Item $classicShellStopScript $classicShellDir
}
catch
{
    <# We should notify that IoD have fail #>
    $ErrorMessage = $_.Except0on.Message
    Write-Verbose "$ErrorMessage"
}

try
{
    <# Currently there is no way of being sure classicShell has exit #>
    $process = Get-Process $ClassicShellProcessName -ea SilentlyContinue

    if ($process)
    {
        Invoke-Command $classicShellPath "-exit" "" 0
        Write-Verbose "Classic-Shell stopped"
    }
}
catch
{
    <# ($_.FullyQualifiedErrorId).split(',')[0] #>
    Write-Verbose ("Failed to restore correct Windows Menu " + $_.FullyQualifiedErrorId)
}

refreshenv

exit 0