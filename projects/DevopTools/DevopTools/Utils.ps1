function ConvertTo-WSLPath {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string]$Path
  )

  $wslPath = $Path -replace '\\', '/'
  $wslPath = [regex]::Replace($wslPath, '^(\w):/', {
      param(
        [System.Text.RegularExpressions.Match]$match
      )
    
      return "/mnt/$($match.Groups[1].Value.ToLower())/"
    }
  )

  return $wslPath
}

$WSLScriptRoot = ConvertTo-WSLPath $MyInvocation.PSScriptRoot
$ConfigPath = Join-Path -Path (Resolve-Path '~') -ChildPath '.devoptools'
