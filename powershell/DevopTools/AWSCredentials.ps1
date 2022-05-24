. $PSScriptRoot\Utils.ps1

$credentialsFilePath = "$ConfigPath\aws-credentials"

<#
.SYNOPSIS
Creates new AWS credentials for the specified user.

.DESCRIPTION
Creates new AWS credentials for the specified user and stores them to the file system.

.PARAMETER UserName
The user name to create credentials for.

.PARAMETER Recreate
Delete the existing credentials if they exist and recreate them.
#>
function New-AWSCredentials {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$UserName,
    [switch]$Recreate
  )

  if (-not (Test-Path $credentialsFilePath)) {
    Write-Verbose "Creating new AWS credentials file at '$credentialsFilePath' ..."
    New-Item $credentialsFilePath -Force -ItemType File 1> $null
  }

  if ($Recreate) {
    $accessKeys = (aws iam list-access-keys --user-name $UserName --query 'AccessKeyMetadata[].AccessKeyId' --output text) -split '\s+'

    Write-Verbose "Recreating AWS credentials for user '$UserName' ..."

    foreach ($accesKey in $accessKeys) {
      aws iam delete-access-key --access-key-id $accesKey --user-name $UserName
    }
  } else {
    if (Test-AwsCredentials $UserName) {
      Write-Error "User '$UserName' already has cached credentials. Pass -Recreate to recreate them."
      Get-Help New-AWSCredentials -Parameter Recreate
      throw
    }

    Write-Verbose "Creating new AWS credentials for user '$UserName'"
  }

  Write-AWSCredentials $UserName
}

<#
.SYNOPSIS
Reads extsisting AWS credentials for the specified user.

.DESCRIPTION
Reads extsisting AWS credentials for the specified user.

.PARAMETER UserName
The user name name to read the credentials for.
#>
function Read-AWSCredentials {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$UserName
  )

  if (-not (Test-AwsCredentials $UserName)) {
    Write-Error "Crendentials not found for user '$UserName'"
    throw
  }

  $accessKey = git config --file $credentialsFilePath --get "$UserName.accessKey"
  $secretKey = git config --file $credentialsFilePath --get "$UserName.secretKey"

  return @{
    AccessKey = $accessKey
    SecretKey = $secretKey
  }
}

<#
.SYNOPSIS
Read extsisting AWS credentials for the specified user.

.DESCRIPTION
Read extsisting AWS credentials for the specified user.

.PARAMETER UserName
The user name to read the credentials for.
#>
function Remove-AWSCredentials {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$UserName
  )

  git config --file $credentialsFilePath --remove-section $UserName
}

function Write-AWSCredentials {
  param(
    [Parameter(Mandatory)]
    [string]$UserName
  )

  $credentials = (aws iam create-access-key --user-name $UserName --query 'AccessKey.[AccessKeyId, SecretAccessKey]' --output text) -split '\s+'

  git config --file $credentialsFilePath "$UserName.accessKey" $credentials[0]
  git config --file $credentialsFilePath "$UserName.secretKey" $credentials[1]
}

function Test-AwsCredentials {
  param(
    [Parameter(Mandatory)]
    [string]$UserName
  )

  return [bool] (git config --get --file $credentialsFilePath "$UserName.accessKey")
}
