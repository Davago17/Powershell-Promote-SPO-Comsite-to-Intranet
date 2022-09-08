<#
PowerShell Script writen by Dave Van Gool - Consultant The Flow (Cronos Group)
This script connects to sharepoint online and promote a Communication page to be the intranet main page.
For this script the module pnp.powerShell is used.
#>

$IntranetPage = Read-Host -Prompt "Please provide the url to the sharepoint site that needs to be promoted" 

Connect-PnPOnline -Url $IntranetPage -LaunchBrowser -Interactive
$UrlSplit = $IntranetPage -split "sites"
$SiteName = $UrlSplit[1].replace("/","")
$Tenant = $UrlSplit[0]
Write-Output "connected to $SiteName(Tenant: $Tenant)"

