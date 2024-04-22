#shellcheck shell=sh

Describe 'strace backend'
  Include './fdspy'

  It 'should generate PID argument'
    When call fdspy 1234 --dry-run
    The stderr should include ' -p 1234 '
  End

  Describe 'write selectors'
    It 'should default to stdout'
      When call fdspy 1234 --dry-run
      The stderr should include ' -e fd=1 '
    End

    It 'should drop default file descriptor when any other is specified'
      When call fdspy 1234 --dry-run --fd 2
      The stderr should include ' -e fd=2 '
      The stderr should not include ' -e fd=1 '
    End

    It 'should accept multiple file descriptors'
      When call fdspy 1234 --dry-run --fd 1 --fd 2
      The stderr should include ' -e fd=1,2 '
    End

    It 'should accept comma-separated file descriptors'
      When call fdspy 1234 --dry-run --fd 1,2
      The stderr should include ' -e fd=1,2 '
    End

    It 'should accept wildcard'
      When call fdspy 1234 --dry-run --fd '*'
      The stderr should not include ' -e fd= '
    End

    Describe 'aliases'
      It '--stdio'
        When call fdspy 1234 --dry-run --stdio
        The stderr should include ' -e fd=1,2 '
      End

      It '--stdout'
        When call fdspy 1234 --dry-run --stdout
        The stderr should include ' -e fd=1 '
      End

      It '--stderr'
        When call fdspy 1234 --dry-run --stderr
        The stderr should include ' -e fd=2 '
      End
    End

    It 'should accept a path'
      When call fdspy 1234 --dry-run --path /tmp/fdspy.log
      The stderr should include " -P '/tmp/fdspy.log' "
    End

    It 'should accept a path with spaces'
      When call fdspy 1234 --dry-run --path '/tmp/with spaces.log'
      The stderr should include " -P '/tmp/with spaces.log' "
    End

    Describe 'forked processes'
      It 'should default to following forks'
        When call fdspy 1234 --dry-run
        The stderr should include ' -f '
      End

      It 'should not follow forks with --ignore-forks'
        When call fdspy 1234 --dry-run --ignore-forks
        The stderr should not include ' -f '
      End

      It 'should re-enable fork following with --forks'
        When call fdspy 1234 --dry-run --ignore-forks --forks
        The stderr should include ' -f '
      End
    End
  End
End
