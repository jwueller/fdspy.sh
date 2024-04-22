#shellcheck shell=sh

Describe 'fdspy_filter_writes_by_fds'
  Include './fdspy'

  It 'should not filter without arguments'
    Data '1 2024-04-22T20:35:16 CEST\n'
    When call fdspy_filter_writes_by_fds
    The output should equal '1 2024-04-22T20:35:16 CEST\n'
  End

  It 'should filter by a single file descriptor'
    Data '1 2024-04-22T20:35:16 CEST\n'
    When call fdspy_filter_writes_by_fds 1
    The output should be blank
  End

  It 'should not filter other file descriptors'
    Data '1 2024-04-22T20:35:16 CEST\n'
    When call fdspy_filter_writes_by_fds 2
    The output should equal '1 2024-04-22T20:35:16 CEST\n'
  End

  It 'should filter by multiple file descriptors'
    Data
      #|1 2024-04-22T20:35:16 CEST\n
      #|2 2024-04-22T20:35:17 CEST\n
      #|3 2024-04-22T20:35:18 CEST\n
    End
    When call fdspy_filter_writes_by_fds 1 3
    The output should equal '2 2024-04-22T20:35:17 CEST\n'
  End
End
