# check locally if storage sense is installed 
# Define the path to the Storage Sense setting in the registry
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy"

# Define the value name to check
$valueName = "01"

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Get the value of Storage Sense setting
    $storageSenseStatus = Get-ItemPropertyValue -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

    if ($null -ne $storageSenseStatus) {
        # Check if Storage Sense is enabled (1) or not (0)
        if ($storageSenseStatus -eq 1) {
            Write-Output "Storage Sense is enabled."
        } else {
            Write-Output "Storage Sense is disabled."
        }
    } else {
        Write-Output "Storage Sense setting not found."
    }
} else {
    Write-Output "Storage Sense registry path does not exist."
}
