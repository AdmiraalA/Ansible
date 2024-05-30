# Define the network path
$networkPath = "\\10.0.180.105\NetWay_map"

# Define the username and password
$username = "gekkegerrit"
$password = "Test1234!"

# Check if the drive is already mapped
if (Test-Path -Path "X:") {
    Write-Output "Drive X: is already mapped."
} else {
    # Map the network drive
    try {
        # Use the NET USE command to map the network drive with credentials
        $cmd = "net use J: $networkPath /user:$username $password /persistent:yes"
        Invoke-Expression -Command $cmd
        Write-Output "Drive X: mapped successfully to $networkPath."
    } catch {
        Write-Error "Failed to map drive X:. Error: $_"
    }
}
