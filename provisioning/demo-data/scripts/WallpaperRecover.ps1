<#
    This scripts recover the previous wallpaper, after setting a
    new one.
#>
$VerbosePreference = "continue"

$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class wallpaper
{
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path )
{
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
}
}
"@
Add-Type -TypeDefinition $setwallpapersrc

$GPII_Demo_Path = "$env:HOMEPATH\AppData\Local\GPII-Demo"
$backedPath = "$GPII_Demo_Path\backed-wallpaper-path"

if (!(Test-Path $GPII_Demo_Path)) {
    Write-Verbose ("Impossible to restore wallpaper, no route to backup")
    exit
}

if (!(Test-Path $backedPath)) {
    Write-Verbose ("Impossible to restore wallpaper, first you need to set a new one")
    exit
}

$backedWp = Get-Content $backedPath
[wallpaper]::SetWallpaper($backedWp)

Remove-Item -Path $backedPath
