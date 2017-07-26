<# 
Script: Check Status of ASE on ILB
Author: Mariusz Kolodziej - Microsoft 
Date: June 13, 2017
Version: 1.0
References:
    TBD

THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
PARTICULAR PURPOSE.

IN NO EVENT SHALL MICROSOFT AND/OR ITS RESPECTIVE SUPPLIERS BE
LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY
DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
OF THIS CODE OR INFORMATION.
#>


# Set Azure AD Tenant name
$adTenant = "microsoft.onmicrosoft.com"

# Set Azure subscription IDs
$subscriptionId = ""
$resourceGroup = "ase-rg"
$aseName = "aseilb"
$apiVersion = "2016-09-01" #https://docs.microsoft.com/en-us/rest/api/appservice/appserviceenvironments#AppServiceEnvironments_Get
$targetRestApi = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Web/hostingEnvironments/aseilb?api-version=$apiVersion"
#$targetRestApi = "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Web/hostingEnvironments/aseilb/serverfarms?api-version=$apiVersion"

Write-Output "Initializing script"

# Load ADAL Assemblies
$adal = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.dll"
$adalforms = "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\ServiceManagement\Azure\Services\Microsoft.IdentityModel.Clients.ActiveDirectory.WindowsForms.dll"
[System.Reflection.Assembly]::LoadFrom($adal)
[System.Reflection.Assembly]::LoadFrom($adalforms)
# Set well-known client ID for Azure PowerShell
$clientId = "1950a258-227b-4e31-a9cf-717495945fc2" 
# Set redirect URI for Azure PowerShell
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"
# Set Resource URI to Azure Service Management API
$resourceAppIdURI = "https://management.core.windows.net/"
# Set Authority to Azure AD Tenant
$authority = "https://login.windows.net/$adTenant"
# Create Authentication Context tied to Azure AD Tenant
$authContext = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" -ArgumentList $authority

# Acquire token
$authResult = $authContext.AcquireToken($resourceAppIdURI, $clientId, $redirectUri, "Auto")

# Create Authorization Header
$authHeader = $authResult.CreateAuthorizationHeader()

# Set HTTP request headers to include Authorization header
$requestHeader = @{
"Content-Type" = "application/json";
"Authorization" = $authHeader.ToString();
"Accept" = "application/json"
}

Write-Output "Getting ASE Info"
$response = $null
# TRY invoke-webrequest to get the status code with out try/catch
$response = try {Invoke-RestMethod -Uri $targetRestApi -Method Get -Headers $requestHeader}
catch {$_.Exception.Response }


Write-Output $(ConvertTo-Json $response.properties)

# Check if we get a 500 or 200
$response.StatusCode.value__
# Check the Healthy propoerty of the ASE, however there is about 30 min. lag when this flag is flipped from true/false 
# based on my testing comparing to the actual REST call vs admin action on ASE api
$response.properties.environmentIsHealthy