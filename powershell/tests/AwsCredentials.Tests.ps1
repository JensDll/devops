﻿BeforeAll {
  Import-Module $PSScriptRoot\..\DevopTools
}

InModuleScope DevopTools {
  Describe 'AwsCredentials' {
    BeforeEach {
      $credentialsFilePath = "$([IO.Path]::GetTempPath())$([Guid]::NewGuid())-aws-credentials"

      New-Item $credentialsFilePath -Force -ItemType File

      Mock aws {
        switch ($args[0] + " " + $args[1]) {
          'iam list-access-keys' {
            return 'access-key-1 access-key-2'
          }
          'iam create-access-key' {
            return 'access-key secret-key'
          }
        }
      }

      Mock Write-Error {}
    }
    
    Describe 'Read-AwsCredentials' {
      BeforeEach {
        # Arrange
        @'
[TestUser]
  accessKey = access-key
  secretKey = secret-key
'@ | Out-File $credentialsFilePath
      }

      It 'should read the credentials' {
        # Act
        $credentials = Read-AwsCredentials -UserName 'TestUser'

        # Assert
        $credentials.AccessKey | Should -Be 'access-key'
        $credentials.SecretKey | Should -Be 'secret-key'
      }

      It 'fail if user does not exist' {
        # Act + Assert
        { Read-AwsCredentials -UserName 'Invalid' } | Should -Throw
        Should -Invoke -CommandName Write-Error -Exactly -Times 1
      }
    }
    
    Describe 'New-AwsCredentials' {
      Describe 'With existing credentials file (<exists>)' -ForEach @(
        @{ exists = $true }
        @{ exists = $false }
      ) {
        Describe 'With -Recreate (<withRecreate>)' -ForEach @(
          @{ withRecreate = $true }
          @{ withRecreate = $false }
        ) {
          BeforeEach {
            # Arrange
            if (-not $exists) {
              Remove-Item $credentialsFilePath
            }

            # Act
            New-AwsCredentials -UserName 'TestUser' -Recreate:$withRecreate
            $credentials = Read-AwsCredentials -UserName 'TestUser'
          }

          # Assert ...
          it -Skip:(-not $withRecreate) 'call iam delete-access-key' {
            Should -Invoke -CommandName 'aws' -Exactly -Times 1 -ParameterFilter { "$args" -match 'iam delete-access-key.+--access-key-id access-key-1' }
            Should -Invoke -CommandName 'aws' -Exactly -Times 1 -ParameterFilter { "$args" -match 'iam delete-access-key.+--access-key-id access-key-2' }
          }

          It 'credentials file exists' {
            $credentialsFilePath | Should -Exist
          }

          it 'call aws iam create-access-key' {
            Should -Invoke -CommandName 'aws' -Exactly -Times 1 -ParameterFilter { "$args" -match 'iam create-access-key.+--user-name TestUser' }
          }

          it 'create new credentials' {
            $credentials.AccessKey | Should -Be 'access-key'
            $credentials.SecretKey | Should -Be 'secret-key'
          }

          it -Skip:$withRecreate 'fail if credentials already exist' {
            { New-AwsCredentials -UserName 'TestUser' } | Should -Throw
            Should -Invoke -CommandName Write-Error -Exactly -Times 1
          }
        }
      }

      AfterEach {
        Remove-Item $credentialsFilePath
      }
    }
  }
}
