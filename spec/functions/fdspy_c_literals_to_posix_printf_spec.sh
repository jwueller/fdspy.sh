#shellcheck shell=sh

Describe 'fdspy_c_literals_to_posix_printf'
  Include './fdspy'

  It 'should not touch printable characters'
    Data 'Hello, fdspy!'
    When call fdspy_c_literals_to_posix_printf
    The output should equal 'Hello, fdspy!'
  End

  Describe 'escape sequences'
    Parameters
      # These are all equivalent to their C counterparts.
      '\a' '\a'
      '\b' '\b'
      '\e' '\e'
      '\f' '\f'
      '\n' '\n'
      '\r' '\r'
      '\t' '\t'
      '\v' '\v'
      "\\\\" "\\\\"
      '\xAF' '\xAF'
      '\u20AC' '\u20AC'
      '\U0001F600' '\U0001F600'

      # POSIX `printf %b` expects octal escape sequences with a leading zero,
      # while C doesn't accept it. `\0` does not require any, but escaping it
      # as `\00` allows using one substitution rule for everything, which is
      # more convenient.
      '\0' '\00'
      '\123' '\0123'

      # These are not valid POSIX `printf %b` escape sequences.
      '\%' '%'
      '\"' '"'
      "\\'" "'"
      '\?' '?'
    End

    It "should translate C $1 to POSIX $2"
      Data "$1"
      When call fdspy_c_literals_to_posix_printf
      The output should equal "$2"
    End
  End
End
