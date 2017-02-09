#Source: http://deploymentresearch.com/Research/Post/578/Building-the-perfect-Windows-Server-2016-reference-image

# Check for elevation
Write-Host "Checking for elevation"

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
    Write-Warning "Aborting script..."
    Break
}

# Configure NTFS Permissions for the MDT Build Lab deployment share
$deploymentShareNTFS = "C:\DeploymentShare\"
#$loggedInUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name # mapping issues
icacls $deploymentShareNTFS /grant ""$($whoami)":(OI)(CI)(RX)"
icacls $deploymentShareNTFS /grant '"Administrators":(OI)(CI)(F)'
icacls $deploymentShareNTFS /grant '"SYSTEM":(OI)(CI)(F)'
icacls "$deploymentShareNTFS\Captures" /grant ""$($whoami)":(OI)(CI)(M)"

# Configure Sharing Permissions for the MDT Build Lab deployment share
$deploymentShare = "MDTBuildLab$"
Grant-SmbShareAccess -Name $deploymentShare -AccountName "EVERYONE" -AccessRight Change -Force
Revoke-SmbShareAccess -Name $deploymentShare -AccountName "CREATOR OWNER" -Force
