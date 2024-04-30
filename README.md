# 🕵️ `fdspy`

**Capture stdout, stderr, and other file descriptors of _running processes_ on-the-fly, without redirects, `screen`, or `tmux`.**

Ever started a long-running process but forgot to redirect the output to a file or run it in `screen`? `fdspy` is a standalone shell script that uses `strace` to monitor writes of already-running processes, ensuring you don’t have to restart your work.

File descriptors are non-negative integers that represent open files, sockets, or other I/O streams. By default, `fdspy` captures writes to standard output (i.e. `stdout` or file descriptor `1`), but you can also monitor other file descriptors or specific files.

## Features

- **Reasonable defaults:** Captures stdout by default, just like piping directly from the process.
- **Multi-Process Monitoring:** Automatically tracks forked processes to keep an eye on complex applications.
- **Flexible Write Selection:** Allows precise control over data capture by selecting writes based on specific file descriptors or paths.

## Requirements

- **`strace`:** `fdspy` relies on `strace` to attach to processes and monitor their system calls.
- **POSIX-compliant shell:** Works with shells like `bash` or even plain `sh`.

## Installation

To use `fdspy`, just download the [latest release](https://github.com/jwueller/fdspy.sh/releases/latest) to where you want it, then make it executable:

```sh
sudo curl -Lo /usr/local/bin/fdspy https://github.com/jwueller/fdspy.sh/releases/latest/download/fdspy
sudo chmod +x /usr/local/bin/fdspy
```

## Examples

Note: Make sure that `fdspy` has the correct permissions to `strace` the process you want to monitor.

### Basic usage

```sh
fdspy 1337                # defaults to stdout if no selectors are given
fdspy $(pgrep rsync)      # dynamic PID discovery
fdspy -- $(pgrep rsync)   # explicit PID separator, exits cleanly if empty
```

### Selecting specific streams

```sh
fdspy 1337 --fd 1     # capture stdout (same as default, but explicit)
fdspy 1337 --stdout   # convenience alias for --fd 1

fdspy 1337 --fd 2     # capture stderr
fdspy 1337 --stderr   # convenience alias for --fd 2

fdspy 1337 --fd 1 --fd 2   # capture both
fdspy 1337 --fd 1,2        # also valid
fdspy 1337 --stdio         # convenience alias for --fd 1,2

fdspy 1337 --fd '*'   # capture everything

# Capture process writes to specific files; behaves like `tail -f <file>`,
# but for a specific process only.
fdspy 1337 --path info.log --path error.log

# Capture muted process output.
fdspy --path /dev/null -- $(pgrep verbose-app)
```

### Output filtering

Note that filtering happens after capture, so it is generally preferable to explicitly select only the streams you are interested in, if feasible.

```sh
fdspy 1337 --fd '*' --ignore-fd 1,2   # everything except stdout and stderr
fdspy 1337 --fd '*' --ignore-stdio    # convenience alias for --ignore-fd 1,2
fdspy 1337 --fd '*' --ignore-stdout   # convenience alias for --ignore-fd 1
fdspy 1337 --fd '*' --ignore-stderr   # convenience alias for --ignore-fd 2
```

### Output encoding

Some examples of what the output might look like for a process `1337`, that writes the non-printable byte `0x01`, `Hello, fdspy!`, and a newline to stdout (see [`test/src/hello_stdout.c`](tools/src/hello_stdout.c)):

```sh
# Raw encoding is the default, and replicates the original output exactly.
# This example uses `cat -v` to illustrate non-printable characters:
fdspy 1337 -x raw | cat -v
# => ^AHello, fdspy!

# For further processing, it can be useful to use a very minimal encoding
# instead:
fdspy 1337 -x hex
# => 01 48 65 6c 6c 6f 2c 20 66 64 73 70 79 21 0a
#    │  └ Hello, fdspy!                        └ line feed
#    └ non-printable 0x01 byte

# Alternatively, you might want to pass the output to a C compiler:
fdspy 1337 -x c
# => \1Hello, fdspy!\n

# However, if you are in a shell environment, POSIX `printf "%b"` is a
# convenient and portable way to access the raw data without having to worry
# about the shell script breaking:
fdspy 1337 -x posix
# => \01Hello, fdspy!\n
```

## Versioning

This project uses [Semantic Versioning](https://semver.org/), so you can expect a new release to indicate backwards-incompatible changes with a new major version number, although those will be avoided if at all possible.

Changes that don't affect user-visible behavior (e.g. documentation, tests, etc.) will not trigger a new version. Please note though that stderr status messages are not considered stable and may vary between minor versions.

## License

Copyright 2024 Johannes Wüller <johanneswueller@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; If not, see <http://www.gnu.org/licenses/>.
