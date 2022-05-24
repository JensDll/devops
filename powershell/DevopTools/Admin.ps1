function Test-Admin() {
  if ($IsWindows) {
    $principal = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
  }
  
  return 0 -eq (id -u)
}

function Invoke-Privileged() {
  param (
    [string[]]$ArgumentList,
    [switch]$LeaveOpen,
    [string]$FunctionName
  )

  if ((Test-Admin) -or -not $IsWindows) {
    return
  }

  if ($FunctionName) {
    Start-Process -FilePath 'pwsh' -Verb RunAs -ArgumentList ($LeaveOpen ? '--noexit' : ''),
    "-Command `"& { . $($MyInvocation.PSCommandPath); $FunctionName $ArgumentList }`""
  } else {
    Start-Process -FilePath 'pwsh' -Verb RunAs -ArgumentList ($LeaveOpen ? '--noexit' : ''),
    $MyInvocation.PSCommandPath,
    "$ArgumentList"
  }
}
