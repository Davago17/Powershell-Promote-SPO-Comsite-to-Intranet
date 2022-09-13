<# PowerShell Script writen by Dave Van Gool - Consultant The Flow / Cronos Group
This script connects to sharepoint online and promote a Communication page to be the intranet main page.
For this script the module pnp.powerShell is used.
#>

$IntranetPage = Read-Host -Prompt "Please provide the url to the sharepoint site that needs to be promoted" 
#Connect-PnPOnline -Url $Tenant -Interactive -LaunchBrowser

Connect-PnPOnline -Url $IntranetPage -LaunchBrowser -Interactive
$UrlSplit = $IntranetPage -split "sites"
$SiteName = $UrlSplit[1].replace("/", "")
$Tenant = $UrlSplit[0]
Write-Output "connected to $SiteName(Tenant: $Tenant)"

$Verify = Read-Host -Prompt "$IntranetPage is this url correct (Y/N)" 
if ($Verify -eq "Y") {
    $HomesiteCheck = Get-PnPHomeSite
    if ($HomesiteCheck -eq $IntranetPage) {
        <#The Url provided is already defined as homesite#>
        Write-Output "The $IntranetPage is already assigned as intranet home site"
    }
    elseif ($Null -eq $HomesiteCheck) {
        <#If no Home Site is defined#>
        Write-Output "There is no Home Site defined , $IntranetPage will be the home site"
        Set-PnPHomeSite -HomeSiteUrl $IntranetPage 
        Write-Output "The $IntranetPage is assigned as the home site"
    }
    elseif ($HomesiteCheck -ne $IntranetPage) {
        <# If there is a site already defined as homesite request user if the Homesite will be changed to the Url provided#>
        Write-Output "The Home Site is $HomesiteCheck"
        $ReplaceHomeSite = Read-Host -Prompt "Do you want to change the $IntranetPage with $HomesiteCheck as default Home Site (Y/N)"
        Switch ($ReplaceHomeSite) {
            Y { Write-Output "Setting the $IntranetPage as default Home Site" | Set-PnPHomeSite -HomeSiteUrl $IntranetPage | Write-Output "The $IntranetPage is assigned as the home site" }
            N { Write-Output "The home site remains $HomesiteCheck" | break }
            Default { Write-Output "Didn't recognize your answer as a valid option" }
        }
    }
}

