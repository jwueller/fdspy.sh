#shellcheck shell=sh

Describe 'fdspy_is_non_negative_integer'
  Include './fdspy'

  It 'should reject empty input'
    When call fdspy_is_non_negative_integer
    The status should be failure
  End

  It 'should accept zero'
    When call fdspy_is_non_negative_integer 0
    The status should be success
  End

  It 'should accept a positive integer'
    When call fdspy_is_non_negative_integer 1
    The status should be success
  End

  It 'should reject a negative integer'
    When call fdspy_is_non_negative_integer -1
    The status should be failure
  End

  It 'should reject alphanumeric input'
    When call fdspy_is_non_negative_integer a
    The status should be failure
  End
End
