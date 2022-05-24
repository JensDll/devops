. $PSScriptRoot\Utils.ps1
. $PSScriptRoot\Admin.ps1

$caHome = "$ConfigPath\root-ca"
$caHomeWSL = ConvertTo-WSLPath $caHome
$hostFilePath = 'C:\Windows\System32\drivers\etc\hosts'

function New-RootCA() {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [string]$Domain
  )

  if (-not (Test-Path "$caHome\private")) {
    New-Item "$caHome\certs", "$caHome\db", "$caHome\private" -ItemType Directory 1> $null
    New-Item "$caHome\db\index" -ItemType File 1> $null
  }
  
  $cert = Get-ChildItem -Path Cert:\CurrentUser\Root -SSLServerAuthentication -DnsName $Domain
  
  if ($cert) {
    Write-Verbose 'Using existing certificate'
  
    $password = New-Object System.Security.SecureString
  
    Export-PfxCertificate -Cert $cert -FilePath "$caHome\certs\tls.p12" -Password $password 1> $null
  
    wsl --exec openssl pkcs12 `
      -in "$caHomeWSL/certs/tls.p12" `
      -out "$caHomeWSL/certs/tls.crt" `
      -nokeys `
      -noenc `
      -password 'pass:'
      
    wsl --exec openssl pkcs12 `
      -in "$caHomeWSL/certs/tls.p12" `
      -out "$caHomeWSL/private/tls.key" `
      -nocerts `
      -noenc `
      -password 'pass:'
        
    return
  }

  wsl --exec "$WSLScriptRoot/create-root-ca.sh" --domain $Domain --home $caHomeWSL
  
  Import-PfxCertificate -FilePath "$caHome\certs\tls.p12" -CertStoreLocation Cert:\CurrentUser\Root -Exportable 1> $null
}

function Add-DNSEntries() {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string]$IPAddress,
    [Parameter(Mandatory, Position = 1)]
    [string]$Domain,
    [Parameter(Position = 2)]
    [string[]]$SubDomains
  )

  $IsVerbose = $PSBoundParameters.ContainsKey('Verbose')

  Invoke-Privileged -FunctionName "Add-DNSEntries" -ArgumentList "-Domain $Domain", 
  "-IPAddress $IPAddress", 
  ($SubDomains ? "-SubDomains $($SubDomains -join ',')" : ''),
  ($IsVerbose ? '-Verbose' : '')

  if (-not (Test-Admin)) {
    return
  }

  Remove-DNSEntries -Domain $Domain

  Write-Verbose "Writing DNS entries to location: $hostFilePath"

  $hasNewlime = (Get-Content $hostFilePath -Raw) -Match [System.Environment]::NewLine + '$'

  $entries = ($hasNewlime ? '' : [System.Environment]::NewLine) + "$IPAddress $Domain # Added by powershell devop tools"

  foreach ($subDomain in $SubDomains) {
    $entries += [System.Environment]::NewLine + "$IPAddress $subDomain.$Domain # Added by powershell devop tools"
  }

  Add-Content -Path $hostFilePath -Value $entries -NoNewline
  
  if ($IsVerbose) {
    Get-Content $hostFilePath -Raw
    Write-Verbose 'Done ... Press Enter to exit:'
    Read-Host > $null
  }
}

function Remove-DNSEntries() {
  param(
    [Parameter(Mandatory)]
    [string]$Domain
  )

  $IsVerbose = $PSBoundParameters.ContainsKey('Verbose')

  Invoke-Privileged -FunctionName 'Remove-DNSEntries' -ArgumentList "-Domain $Domain",
  ($IsVerbose ? '-Verbose' : '')

  if (-not (Test-Admin)) {
    return
  }

  $lines = @()

  foreach ($line in Get-Content $hostFilePath) {
    if ($line -NotMatch "$Domain # Added by powershell devop tools") {
      $lines += $line
    }
  }

  $lines | Out-File $hostFilePath

  if ($IsVerbose) {
    Get-Content $hostFilePath -Raw
    Write-Verbose 'Done ... Press Enter to exit:'
    Read-Host > $null
  }
}