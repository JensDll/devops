. $PSScriptRoot\AwsCredentials.ps1

$exportModuleMemberParams = @{
  Function = $(
    'New-AwsCredentials',
    'Read-AwsCredentials',
    'Remove-AwsCredentials'
  )
}

Export-ModuleMember @exportModuleMemberParams