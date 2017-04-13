try 
{
    & "C:\Program Files\Classic Shell\ClassicStartMenu.exe" -exit
}
catch
{
    echo $_.Exception|format-list -force # -foreground Red
    Write-Host "At line:" -foreground Red
    Write-Host "$($_.InvocationInfo.ScriptName)($($_.InvocationInfo.ScriptLineNumber)): $($_.InvocationInfo.Line)"
}