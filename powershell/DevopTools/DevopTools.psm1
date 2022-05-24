. $PSScriptRoot\AWSCredentials.ps1
. $PSScriptRoot\Admin.ps1
. $PSScriptRoot\TLS.ps1
. $PSScriptRoot\Utils.ps1

$export = @{
  Function = $(
    # AWS
    'New-AWSCredentials',
    'Read-AWSCredentials',
    'Remove-AWSCredentials',
    
    # Admin
    'Test-Admin',
    'Invoke-Privileged',

    # TLS
    'New-RootCA',
    'Add-DNSEntries',
    'Remove-DNSEntries',

    # Utils
    'ConvertTo-WSLPath'
  )
  Variable = $(
    # Utils
    'WSLScriptRoot'
  )
}

Export-ModuleMember @export
