# Docker containers for YARA

Dockerfile which allows to install [YARA-X](https://github.com/VirusTotal/yara-x) in a Linux Debian docker container with Rust already installed.

You may add YARA rules in the ```rules``` directory. These will be copied into the ```/root/rules``` directory of the container.


## Building a container

The following command will build a container for YARA-X (```main``` branch):

```
docker build -t yara-x .
```

The container can then be run using the following command:

```
docker run -v <path-to-samples>:/tmp/samples -it --rm yara-x
```

In the container, run ```yr``` from the command line to perform a scan. For example:

```
# yr scan rules/dummy.yar /tmp/samples/
```


Running ```yr help``` provide you with the help menu of yara-x-cli:

```
# yr help
An experimental implementation of YARA in Rust

Victor M. Alvarez <vmalvarez@virustotal.com>

Usage:
    yr [COMMAND]

Commands:
  scan     Scan a file or directory
  compile  Compile rules to binary form
  check    Check if source files are syntactically correct
  dump     Show the data produced by YARA modules for a file
  fmt      Format YARA source files
  help     Print this message or the help of the given subcommand(s)

Options:
  -h, --help     Print help
  -V, --version  Print version
```

Please refer to the [YARA-X](https://github.com/VirusTotal/yara-x) repository for more information.
