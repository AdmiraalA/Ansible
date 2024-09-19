param (
    [string]$emailaccount,
    [bool]$disable_login,
    [bool]$convert_to_shared,
    [bool]$disassociate_licenses,
    [bool]$grant_access,
    [string]$access_username
)

# Authenticate and get access token
$tenantId = "your-tenant-id"
$clientId = "your-client-id"
$clientSecret = "your-client-secret"
$scope = "https://graph.microsoft.com/.default"

$tokenRequest = @{
    Uri     = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
    Method  = "POST"
    Headers = @{ "Content-Type" = "application/x-www-form-urlencoded" }
    Body    = @{
        grant_type    = "client_credentials"
        client_id     = $clientId
        client_secret = $clientSecret
        scope         = $scope
    }
}

$response = Invoke-RestMethod @tokenRequest
$accessToken = $response.access_token

# Manage mailbox
$uri = "https://graph.microsoft.com/v1.0/users/$emailaccount"

if ($disable_login) {
    Invoke-RestMethod -Uri $uri -Method PATCH -Headers @{ Authorization = "Bearer $accessToken" } -Body @{ accountEnabled = $false } -ContentType "application/json"
}

if ($convert_to_shared) {
    # Convert mailbox to shared
    $sharedMailboxUri = "https://graph.microsoft.com/v1.0/users/$emailaccount"
    Invoke-RestMethod -Uri $sharedMailboxUri -Method PATCH -Headers @{ Authorization = "Bearer $accessToken" } -Body @{ mailboxSettings = @{ isSharedMailbox = $true } } -ContentType "application/json"
    if ($disassociate_licenses) {
        # Remove licenses
        $licensesUri = "https://graph.microsoft.com/v1.0/users/$emailaccount/licenseDetails"
        $licenses = Invoke-RestMethod -Uri $licensesUri -Method GET -Headers @{ Authorization = "Bearer $accessToken" }
        foreach ($license in $licenses.value) {
            Invoke-RestMethod -Uri "$licensesUri/$($license.skuId)" -Method DELETE -Headers @{ Authorization = "Bearer $accessToken" }
        }
    }
}

if ($grant_access) {
    # Grant access to the shared mailbox
    $permissionUri = "https://graph.microsoft.com/v1.0/users/$emailaccount/permissions"
    $body = @{
        userPrincipalName = $access_username
        permissionType    = "FullAccess"
    }
    Invoke-RestMethod -Uri $permissionUri -Method POST -Headers @{ Authorization = "Bearer $accessToken" } -Body $body -ContentType "application/json"
}
