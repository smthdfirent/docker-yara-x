# Docker containers for YARA

Dockerfile which allows to install [YARA-X](https://github.com/VirusTotal/yara-x) in a Linux Debian docker container with Rust already installed.

By default, YARA-X v0.3.0 will be installed.

You may add YARA rules in the ```rules``` directory. These will be copied into the ```/root/rules``` directory of the container.


## Building a container

The following command will build a container for YARA-X (```main``` branch):

```
docker build -t yara-x:v0.3.0 .
```

The container can then be run using the following command:

```
docker run -v <path-to-samples>:/tmp/samples -it --rm yara-x:v0.3.0
```

## Building a container for a specific version of YARA-X

A specific version of YARA-X can also be specified. For example, the following command allows to build a container for YARA-X v0.2.1:

```
docker build --build-arg yarax_version=v0.2.1 -t yara-x-v0.2.1:v0.2.1 .
```


Then, the container can be run using the following command:

```
docker run -v <path-to-samples>:/tmp/samples -it --rm yara-x-v0.2.1:v0.2.1
```


## How to use YARA-X?


In the container, run ```yr``` from the command line to perform a scan. For example:

```
# yr scan rules/dummy.yar /tmp/samples/
```


Running ```yr help``` provides you with the help menu of yara-x-cli:

```
# yr help
A command-line interface for YARA-X.


Victor M. Alvarez <vmalvarez@virustotal.com>

Usage:
    yr [COMMAND]

Commands:
  scan        Scan a file or directory
  compile     Compile rules to binary form
  dump        Show the data produced by YARA modules for a file
  completion  Output shell completion code for the specified shell
  help        Print this message or the help of the given subcommand(s)

Options:
  -h, --help     Print help
  -V, --version  Print version
```

Please refer to the [YARA-X](https://github.com/VirusTotal/yara-x) repository for more information.
