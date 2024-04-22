#shellcheck shell=sh

Describe 'fdspy_parse_strace_writes'
  Include './fdspy'

  It 'should parse "write" syscall'
    Data 'write(1, "2024-04-22T20:35:16 CEST\n", 25) = 25'
    When call fdspy_parse_strace_writes
    The output should equal '1 2024-04-22T20:35:16 CEST\n'
  End

  It 'should parse syscall with leading PID'
    Data '3836326 write(1, "2024-04-22T20:35:16 CEST\n", 25) = 25'
    When call fdspy_parse_strace_writes
    The output should equal '1 2024-04-22T20:35:16 CEST\n'
  End

  It 'should parse syscall with leading bracketed PID'
    Data '[pid 3836326] write(1, "2024-04-22T20:35:16 CEST\n", 25) = 25'
    When call fdspy_parse_strace_writes
    The output should equal '1 2024-04-22T20:35:16 CEST\n'
  End

  It 'should parse "send" syscall'
    Data 'send(3, "\1\2\3\4", 4, 0) = 4'
    When call fdspy_parse_strace_writes
    The output should equal '3 \1\2\3\4'
  End

  It 'should parse "sendto" syscall'
    Data 'sendto(3, "\1\2\3\4", 4, 0, {sa_family=0x2, sin_port="\x00\x00", sin_addr="\x01\x01\x01\x01"}, 16) = 4'
    When call fdspy_parse_strace_writes
    The output should equal '3 \1\2\3\4'
  End

  It 'should ignore "poll" syscall'
    Data 'poll([{fd=3, events=0x1}], 1, 987) = 0 (Timeout)'
    When call fdspy_parse_strace_writes
    The output should be blank
  End
End
