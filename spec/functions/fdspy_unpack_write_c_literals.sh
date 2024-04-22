#shellcheck shell=sh

Describe 'fdspy_unpack_write_c_literals'
  Include './fdspy'

  It 'should extract data column'
    Data '1 2024-04-22T20:35:16 CEST\n'
    When call fdspy_unpack_write_c_literals
    The output should equal '2024-04-22T20:35:16 CEST\n'
  End
End
