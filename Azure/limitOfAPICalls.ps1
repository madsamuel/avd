# To Do: move to input parameters
$subscriptionid = "270b2a02-d1c1-4d6a-84e7-33aea55284b8"
$TenantId = "1187b25e-a3ca-4f6a-a6f9-700c803d4280"

# prerequeisuites
# To Do: put in a try
#region
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
Import-Moduel Az
#endregion

# 
Connect-AzAccount -TenantId $TenantId
Set-AzContext -Subscription $subscriptionid # Azure AD

function Get-AccessToken {
   $context = Get-AzContext
   $profile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
   $profileClient = New-Object -TypeName Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient -ArgumentList ($profile)
   $token = $profileClient.AcquireAccessToken($context.Subscription.TenantId)
   return $token.AccessToken
}

$rm_endpoint = "https://management.azure.com"

$authHeader = @{
   'Content-Type'  = 'application/json'
   'Authorization' = 'Bearer ' + (Get-AccessToken)
}

$uri = "https://management.azure.com/subscriptions/$subscriptionid/resourcegroups?api-version=2016-09-01"

$response = Invoke-RestMethod -Method Get -Headers $authHeader -Uri $uri
$response
$response.Headers

# Fixes old PS6 compat
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$r = Invoke-WebRequest -Uri https://management.azure.com/subscriptions/9e54edf9-6fee-4b75-a9a4-d6d9dc9ac4f0/resourcegroups?api-version=2016-09-01 -Method GET -Headers $authHeader -UseBasicParsing
$r.Headers["x-ms-ratelimit-remaining-subscription-reads"]

# Stupid load testing
For ($i=0; $i -le 1000; $i++) {
      $r = Invoke-WebRequest -Uri https://management.azure.com/subscriptions/9e54edf9-6fee-4b75-a9a4-d6d9dc9ac4f0/resourcegroups?api-version=2016-09-01 -Method GET -Headers $authHeader -UseBasicParsing
      $r.Headers["x-ms-ratelimit-remaining-subscription-reads"]   
   }