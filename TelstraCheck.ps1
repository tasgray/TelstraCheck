# --------------------------------------------------------------
#
# TelstraCheck.ps1
#
# --------------------------------------------------------------
#
# Using delegated administrator credentials, checks each 
# tenant and determines if syndicated with Telstra. Results
# are displayed in a gridview for easy filtering and sorting.
# 
# Note - applies to Australia only. Syndication in other 
#        countries may mean something different.
#
# --------------------------------------------------------------

# Import the modules
Connect-MsolService -Credential $cred

$tenantArray = @()

# Get list of tenants & loop
Get-MsolPartnerContract -All | ForEach { 
    
    $telstra = $false;

    $tenantDetails = @{}
    $tenantDetails.TenantName = [string]$_.DefaultDomainName
    $tenantDetails.Telstra = $false
    
    Get-MsolAccountSku -TenantId $_.TenantId.Guid | Foreach { if($_.AccountName -eq "syndication-account") { $tenantDetails.Telstra = $true } }
     
    $object = New-Object -TypeName PSObject -Prop $tenantDetails
    $tenantArray += $object

}

$tenantArray | Out-GridView