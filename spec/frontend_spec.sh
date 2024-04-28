#shellcheck shell=sh

Describe 'frontend'
  Include './fdspy'

  It 'should fail with usage information if no arguments given'
    When call fdspy
    The stderr should include 'Usage:'
    The status should be failure
    The status should equal 64 # EX_USAGE
  End

  Describe '--help'
    It 'should print help information'
      When call fdspy -h
      The stdout should include 'General options:'
      The status should be success
    End

    It 'should print help information'
      When call fdspy --help
      The stdout should include 'General options:'
      The status should be success
    End
  End

  Describe '--version'
    It 'should print version information'
      When call fdspy --version
      The stdout should start with "fdspy ${FDSPY_VERSION}"
      The status should be success
    End

    It 'should print only the version number with --quiet'
      When call fdspy --version --quiet
      The stdout should eq "${FDSPY_VERSION}"
      The status should be success
    End
  End

  Describe 'positional arguments'
    It 'should accept explicit positional arguments'
      When call fdspy --
      The stdout should be blank
      The stderr should be blank
      The status should be success
    End

    It 'should fail with invalid PID argument'
      When call fdspy -- 0
      The stderr should include 'Invalid process id'
      The status should be failure
    End

    It 'should treat non-option argument as positional argument'
      When call fdspy 0
      The stderr should include 'Invalid process id'
      The status should be failure
    End
  End

  It 'should print the command with --dry-run'
    When call fdspy 1234 --dry-run
    The stderr should include ' strace '
  End
End
