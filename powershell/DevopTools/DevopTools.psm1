. $PSScriptRoot\AwsCredentials.ps1

$export = @{
  Function = $(
    'New-AwsCredentials',
    'Read-AwsCredentials',
    'Remove-AwsCredentials'
  )
}

Export-ModuleMember @export