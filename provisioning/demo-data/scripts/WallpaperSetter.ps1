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

$wPath = (Get-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper).Wallpaper
$nWPath = "C:$GPII_Demo_Path\wallpapers\img0.jpg"
$backedPath = "$GPII_Demo_Path\backed-wallpaper-path"

if (!(Test-Path $GPII_Demo_Path)) {
    New-Item -Path $GPII_Demo_Path -ItemType 'directory'
}

# Backup the previos wallpaper path to the file $backedPath
if (Test-Path $backedPath) {
    $error = "You need to recover previous wallpaper before setting a new one."
    Write-Verbose ($error)
    exit
} else {
    New-Item -Path $backedPath -ItemType "file" -Value $wPath -ErrorAction SilentlyContinue | Out-Null
}

Write-Verbose ("The path: " + $nWPath)
[wallpaper]::SetWallpaper($nWPath) 
