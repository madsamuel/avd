# disable storage sense on mulutple hostpools
# missing auth to azure 
# Define variables
$poolName = "MyAVDHostPool"

# Get session host VMs in the AVD host pool
$sessionHostVMs = Get-AzWvdSessionHost -ResourceGroupName "MyAVDResourceGroup" -WorkspaceName "MyAVDWorkspace" -HostPoolName $poolName

# Disable Storage Sense on each VM
foreach ($vm in $sessionHostVMs) {
    $vmName = $vm.Name
    Write-Output "Disabling Storage Sense on VM: $vmName ..."
    Invoke-AzVmScriptExtension -ResourceGroupName "MyAVDResourceGroup" `
        -VMName $vmName `
        -Location $vm.Location `
        -Name "DisableStorageSense" `
        -Publisher Microsoft.Compute `
        -Type CustomScriptExtension `
        -TypeHandlerVersion 1.9 `
        -SettingString '{"commandToExecute":"powershell.exe Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters /v Enabled /t REG_DWORD /d 0"}' | Out-Null
}

