$url = "https://go.microsoft.com/fwlink/?linkid=2187217&clcid=0x409&culture=en-us&country=us"
$executable = "Teams_windows_x64.exe"

# Download installer
Write-Output "Downloading Microsoft Teams installer..."
Invoke-WebRequest $url -OutFile "$env:TEMP\$executable"

# Install Teams
Write-Output "Installing Microsoft Teams..."
Start-Process -FilePath "$env:TEMP\$executable" -ArgumentList "--silent --installLocation `"C:\Program Files (x86)\Microsoft\Teams`"" -Wait

# Check if installation was successful
$isInstalled = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Microsoft Teams*"} | Select-Object Name, Version
if ($isInstalled.Version) {
    Write-Output "Microsoft Teams has been successfully installed!"
} else {
    Write-Error "Installation failed"
}