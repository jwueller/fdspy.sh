#shellcheck shell=sh

Describe 'fdspy_quote_argument'
  Include './fdspy'

  It 'should quote simple string'
    When call fdspy_quote_argument 'a b'
    The stdout should equal "'a b'"
  End

  It 'should quote string with double quote'
    When call fdspy_quote_argument 'a"b'
    The stdout should equal "'a\"b'"
  End

  It 'should quote string with single quote'
    When call fdspy_quote_argument "a'b"
    The stdout should equal "'a'\\''b'"
  End

  It 'should quote with escape sequences'
    When call fdspy_quote_argument 'a\nb'
    The stdout should equal "'a\\nb'"
  End

  It 'should not double-escape escape character'
    When call fdspy_quote_argument 'a\\nb'
    # Note: This just looks different weird because it's in double quotes, but
    # it's the same string!
    The stdout should equal "'a\\\\nb'"
  End
End
