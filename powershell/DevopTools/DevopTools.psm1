. $PSScriptRoot\AWSCredentials.ps1
. $PSScriptRoot\Admin.ps1
. $PSScriptRoot\ca\CA.ps1

$export = @{
  Function = $(
    'New-AWSCredentials',
    'Read-AWSCredentials',
    'Remove-AWSCredentials',
    'New-RootCA'
  )
}

if ($IsWindows) {
  $export.Function += 'Test-Admin', 'Invoke-Privileged'
}

Export-ModuleMember @export
