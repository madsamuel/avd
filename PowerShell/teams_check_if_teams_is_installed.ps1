# not working
$ErrorActionPreference = 'Stop'

$TeamsInstalled = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -like "*Microsoft Teams*"}

if($TeamsInstalled){
    Write-output "Microsoft Teams is installed"
}
else {
    Write-output "Microsoft Teams is not installed"
}