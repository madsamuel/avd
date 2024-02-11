#description: Install Microsoft Teams from URL  
  
$teamsInstallerUrl = "https://go.microsoft.com/fwlink/?linkid=2187217&clcid=0x409&culture=en-us&country=us"  
$teamsInstallerPath = "$env:TEMP\TeamsSetup.exe"  
  
# Download Microsoft Teams installer  
Invoke-WebRequest -Uri $teamsInstallerUrl -OutFile $teamsInstallerPath  
  
# Install Microsoft Teams  
Start-Process -FilePath $teamsInstallerPath -ArgumentList "/silent" -Wait  
  
# Clean up the installer  
Remove-Item -Path $teamsInstallerPath -Force  
  
Write-Output "Microsoft Teams installed successfully"  
