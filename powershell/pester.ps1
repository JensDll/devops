param(
  [switch]$AsAdmin
)

Import-Module "$PSScriptRoot\DevopTools" -Force -Function 'Invoke-Privileged'

If ($AsAdmin) {
  Invoke-Privileged -ArgumentList '-AsAdmin'
}

$config = New-PesterConfiguration

$config.Run.Container = $(
  (New-PesterContainer -Path .\tests\AwsCredentials.Tests.ps1),
  (New-PesterContainer -Path .\tests\Admin.Tests.ps1 -Data @{ IsAdmin = $AsAdmin })
)

$config.Output.Verbosity = 'Detailed'

Invoke-Pester -Configuration $config
