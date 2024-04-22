#shellcheck shell=sh

Describe 'fdspy_posix_printf_to_raw'
  Include './fdspy'

  It 'should not touch printable characters'
    Data 'Hello, fdspy!'
    When call fdspy_posix_printf_to_raw
    The output should equal 'Hello, fdspy!'
  End

  Describe 'escape sequences'
    Parameters
      # To validate that these produce the expected bytes, we use exact byte
      # values to check against.
      '\a' '\x07'
      '\b' '\x08'
      '\e' '\x1B'
      '\f' '\x0C'
      '\n' '\x0A'
      '\r' '\x0D'
      '\t' '\x09'
      '\v' '\x0B'
      "\\\\" '\x5C'
      '\123' '\x53'
      '\xAF' '\xAF'

      # TODO: How to deal with unicode escape sequences, if at all? Their byte
      #       representation depends on the encoding, so it's unclear which
      #       one to use for the test.

      # These do not have to be escaped in POSIX `printf %b`, but we want to
      # make sure that they are at least interpreted as literal characters. They
      # are defined in C, so it's nice to be able to just pass them through.
      '"' '\x22'
      "'" '\x27'
      '?' '\x3F'
    End

    raw() {
      %printf "$1"
    }

    It "should interpret $1 as $2"
      Data "$1"
      When call fdspy_posix_printf_to_raw
      The output should equal "$(raw "$2")"
    End
  End
End
