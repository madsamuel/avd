# UPDATE ACTIVE DIRECTORY

# Edit Identity to match AD security group for host pool
$ADGroupDN = "CN=SecurityGroup,OU=WVD,OU=Azure,OU=Custom Security Groups,DC=domainname,DC=local"

# Key controlling Optional Components details.
$RegistryPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing"

# Ensure registry key is controlling Optional Components details is created.
# Note: This should be created by default, but in case it's not, do it!
If (!(Test-Path $RegistryPath)) {New-Item -Path $RegistryPath -Force}

# Enable Optional Component updates via Microsoft Windows Updates to install RSAT tools in WSUS environment.
New-ItemProperty -Path $RegistryPath -Name RepairContentServerSource -Value "2" -PropertyType DWORD -Force

Get-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0" -Online | Add-WindowsCapability -Online

Import-Module -Name ActiveDirectory

[pscredential] $domaincred = New-Object system.management.automation.pscredential ($ADUsername,(convertto-securestring $ADPassword -asplaintext -force))

$DomainInfo = Get-WmiObject -Class win32_ntdomain
$DC = (($DomainInfo | ? {$null -ne $_.domainControllername}).DomainControllerName -replace "\\","")
$Domain = $DomainInfo.DnsForestName
$DCFQDN = "fqdn.domainname.local"
#$DCFQDN = ($DC+"."+$Domain -replace "\s","")

$Group = Get-ADGroup -Identity $ADGroupDN -Server $DCFQDN -credential $domaincred

Add-ADGroupMember -Identity $Group -Members ($AzureVMName+'$') -Server $DCFQDN -credential $domaincred

# Disable Optional Components via Microsoft Windows Updates after installing RSAT tools.
    Remove-ItemProperty -Path $RegistryPath -Name RepairContentServerSource

Remove-WindowsCapability -Name "Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0" -Online