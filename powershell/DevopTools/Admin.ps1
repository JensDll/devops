function Test-Admin() {
  if ($IsWindows) {
    $principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }
  
  return 0 -eq (id -u)
}

function Invoke-Privileged() {
  [CmdletBinding()]
  param (
    [string]$Function,
    [Parameter(ValueFromRemainingArguments)]
    [string]$Arguments
  )

  if ((Test-Admin) -or -not $IsWindows) {
    return
  }

  $isVerbose = $PSBoundParameters['Verbose'] -eq $true
  $isDebug = $PSBoundParameters['Debug'] -eq $true

  $PSBoundParameters.Remove('Function') > $null
  $PSBoundParameters.Remove('Verbose') > $null
  $PSBoundParameters.Remove('Debug') > $null
  $PSBoundParameters.Remove('Arguments') > $null

  $boundArgs = ($PSBoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key) $($_.Value)" }) -join ' '

  if ($Function) {
    Start-Process -FilePath 'pwsh' -Verb RunAs -ArgumentList '-Command', ". $($MyInvocation.PSCommandPath); $Function $boundArgs $Arguments",
    ($isVerbose ? '-Verbose' : ''), ($isDebug ? '-Debug' : '')
  } else {
    Start-Process -FilePath 'pwsh' -Verb 'RunAs' -ArgumentList $MyInvocation.PSCommandPath
  }
}
