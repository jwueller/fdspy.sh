#shellcheck shell=sh

Describe 'fdspy_posix_printf_to_hex'
  Include './fdspy'

  It 'should be line-based'
    Data
      #|First
      #|Second
      #|Third
    End
    When call fdspy_posix_printf_to_hex
    The output line 1 should equal '46 69 72 73 74'
    The output line 2 should equal '53 65 63 6f 6e 64'
    The output line 3 should equal '54 68 69 72 64'
  End

  Describe 'escape sequences'
    Parameters
      # To validate that these produce the expected bytes, we use exact byte
      # values to check against.
      '\a' '07'
      '\b' '08'
      '\e' '1b'
      '\f' '0c'
      '\n' '0a'
      '\r' '0d'
      '\t' '09'
      '\v' '0b'
      "\\\\" '5c'
      '\123' '53'
      '\xAF' 'af'

      # TODO: How to deal with unicode escape sequences, if at all? Their byte
      #       representation depends on the encoding, so it's unclear which
      #       one to use for the test.
    End

    It "should interpret $1 as $2"
      Data "$1"
      When call fdspy_posix_printf_to_hex
      The output should equal "$2"
    End
  End
End
