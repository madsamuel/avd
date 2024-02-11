$teamsPah = "C:\Users\ssa\AppData\Local\Microsoft\Teams\Update.exe"

Write-Output "Uninstalling Microsoft Teams..."
Start-Process -FilePath $teamsPah -ArgumentList "--uninstall --slient" -Wait

# Check if uninstallation was successful
$isInstalled = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Microsoft Teams*"} | Select-Object Name, Version
if (!$isInstalled.Version) {
    Write-Output "Microsoft Teams has been successfully uninstalled!"
} else {
    Write-Error "Uninstallation failed"
}

if(Get-AppxPackage *office* | Where-Object {$_.Name -like "*Microsoft.Office.Desktop*"}){
    Write-output "Office 365 is currently installed"}