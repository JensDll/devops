param (
  [Parameter(Mandatory)]
  [bool] $IsAdmin
)

BeforeAll {
  Import-Module $PSScriptRoot\..\DevopTools -Force
}

Describe 'Admin' {
  Describe 'Test-Admin' {
    It 'return <IsAdmin>' {
      Test-Admin | Should -Be $IsAdmin
    }
  }
}