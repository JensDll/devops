function Test-Admin() {
  $principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Invoke-Privileged() {
  param (
    [string[]]$ArgumentList,
    [switch]$LeaveOpen
  )

  if (-not (Test-Admin)) {
    Start-Process -FilePath 'pwsh' -Verb RunAs -ArgumentList ($LeaveOpen ? '--noexit' : ''), $MyInvocation.PSCommandPath, "$ArgumentList"
    exit 0
  }
}