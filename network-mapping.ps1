# Define the network path
$networkPath = "\\ServerName\SharedFolder"

# Optional: If the network path requires credentials, use these variables
$username = "gekkegerrit@netwee.onmicrosoft.com"
# $password = "Password"
# $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
# $credential = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# Check if the drive is already mapped
if (Test-Path -Path "X:") {
    Write-Output "Drive X: is already mapped."
} else {
    # Map the network drive
    try {
        # Uncomment and use the -Credential parameter if credentials are required
        # New-PSDrive -Name "X" -PSProvider "FileSystem" -Root $networkPath -Persist -Credential $credential
        
        New-PSDrive -Name "X" -PSProvider "FileSystem" -Root $networkPath -Persist
        Write-Output "Drive X: mapped successfully to $networkPath."
    } catch {
        Write-Error "Failed to map drive X:. Error: $_"
    }
}
