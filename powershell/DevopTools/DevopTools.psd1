@{
  # Script module or binary module file associated with this manifest.
  RootModule        = 'DevopTools.psm1'

  # Version number of this module.
  ModuleVersion     = '0.0.1'

  # ID used to uniquely identify this module
  GUID              = '0d0e7a69-7247-4979-a599-73850459367e'

  # Author of this module
  Author            = 'Jens Döllmann'

  # Copyright statement for this module
  Copyright         = 'Copyright (c) 2022 Jens Döllmann'

  # Description of the functionality provided by this module
  Description       = 'Devop tools for PowerShell'

  # Minimum version of the PowerShell engine required by this module
  PowerShellVersion = '5.0'

  # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
  FunctionsToExport = @(
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

  # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
  CmdletsToExport   = @()

  # Variables to export from this module
  VariablesToExport = $(
    # Utils
    'WSLScriptRoot'
  )

  # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
  AliasesToExport   = @()

  # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
  PrivateData       = @{
    PSData = @{
      # Tags applied to this module. These help with module discovery in online galleries.
      Tags       = @('powershell', 'devops', 'Windows', 'Linux', 'MacOS')

      # A URL to the license for this module.
      LicenseUri = 'https://github.com/JensDll/devops/blob/main/powershell/LICENSE'

      # A URL to the main website for this project.
      ProjectUri = 'https://github.com/JensDll/devops/tree/main/powershell'
    }
  }
}
