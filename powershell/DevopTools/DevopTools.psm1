. $PSScriptRoot\AwsCredentials.ps1
. $PSScriptRoot\Admin.ps1

$export = @{
  Function = $(
    'New-AwsCredentials',
    'Read-AwsCredentials',
    'Remove-AwsCredentials',
    'Test-Admin',
    'Invoke-Privileged'
  )
}

Export-ModuleMember @export