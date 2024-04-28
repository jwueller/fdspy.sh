#shellcheck shell=sh

Describe 'fdspy_merge_non_negative_integers'
  Include './fdspy'

  It 'should accept no input'
    When call fdspy_merge_non_negative_integers
    The output should be blank
  End

  It 'should accept a single integer'
    When call fdspy_merge_non_negative_integers 1
    The output should eq '1'
  End

  It 'should accept multiple arguments'
    When call fdspy_merge_non_negative_integers 1 2 3
    The output should eq '1 2 3'
  End

  It 'should accept multiple IFS separated integers'
    When call fdspy_merge_non_negative_integers '1 2 3'
    The output should eq '1 2 3'
  End

  It 'should accept mixed arguments'
    When call fdspy_merge_non_negative_integers 1 '2 3'
    The output should eq '1 2 3'
  End

  It 'should reject negative integers'
    When call fdspy_merge_non_negative_integers '-1'
    The stderr should include 'expected non-negative integer: -1'
    The status should be failure
    The status should equal 64 # EX_USAGE
  End

  It 'should accept comma-separated integers'
    When call fdspy_merge_non_negative_integers '1,2,3'
    The output should eq '1 2 3'
  End

  It 'should reject negative integers in comma-separated list'
    When call fdspy_merge_non_negative_integers '1,-2,3'
    The stderr should include 'expected non-negative integer: -2'
    The status should be failure
    The status should equal 64 # EX_USAGE
  End

  It 'should fail gracefully on glob attempts'
    When call fdspy_merge_non_negative_integers '*'
    The stderr should include 'expected non-negative integer: *'
    The status should be failure
    The status should equal 64 # EX_USAGE
  End
End
