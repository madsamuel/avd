# Connect to Azure and select the appropriate Azure Virtual Desktop environment
Connect-AzAccount

# Specify the necessary details for Azure Virtual Desktop
$resourceGroupName = "<Resource Group Name>"
$workspaceName = "<Workspace Name>"
$hostPoolName = "<Host Pool Name>"

# Get the host pool object
$hostPool = Get-AzWvdHostPool -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -Name $hostPoolName

# Retrieve all session hosts within the host pool
$sessionHosts = Get-AzWvdSessionHost -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -HostPoolName $hostPoolName

# Remove each session host from the host pool
foreach ($sessionHost in $sessionHosts) {
    Write-Host "Removing session host $($sessionHost.Name)..."
    Remove-RdsSessionHost -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName -HostPoolName $hostPoolName -SessionHostName $sessionHost.Name -Force
    Write-Host "Session host $($sessionHost.Name) removed successfully."
}

Write-Host "All session hosts have been removed from the host pool."
