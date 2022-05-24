﻿param(
  [switch]$AsAdmin
)

Import-Module $PSScriptRoot\DevopTools -Force -Function 'Invoke-Privileged', 'Test-Admin'

If ($AsAdmin -and $IsWindows) {
  Invoke-Privileged -ArgumentList '-AsAdmin'

  If (-not (Test-Admin)) {
    return
  }
}

$config = New-PesterConfiguration

$config.Run.Container = $(
  (New-PesterContainer -Path .\tests\AWSCredentials.Tests.ps1),
  (New-PesterContainer -Path .\tests\Admin.Tests.ps1 -Data @{ IsAdmin = $AsAdmin })
)

if ($Env:CI -eq 'true') {
  $config.run.Throw = $true
}

$config.Output.Verbosity = 'Detailed'

Invoke-Pester -Configuration $config
