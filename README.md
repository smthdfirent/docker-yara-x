# Docker containers for YARA-X

Dockerfile which allows to install [YARA-X](https://github.com/VirusTotal/yara-x) in a Linux Debian docker container.

You may add YARA rules in the ```rules``` directory. These will be copied into the ```${username}``` home directory of the container (default: ```/home/user/rules```).

You may also add Jupyter notebooks in the ```notebooks``` directory that will be copied into the ```/home/${username}/notebooks```. By default, the container will start a Jupyter notebook server (exposed on port 8080), allowing to use the Python library for YARA-X in Jupyter notebooks.


## Disclaimer

This Dockerfile is intended **to be used in an isolated analysis environment, for testing or development purpose only**.


## Building a container

The following command will build a container for YARA-X (```main``` branch):

```
docker build -t yara-x:v0.5.0 .
```

The container can then be run using the following command:

```
docker run -v <path-to-samples>:/tmp/samples -it --rm yara-x:v0.5.0
```

Building the container without the ```run_jupyter``` parameter set to ```false``` will result in jupyter notebook being run at startup. The following command allows to build a container which will not run jupyter notebook:

```
docker build -t yara-x:v0.5.0 . --build-arg run_jupyter=false
```

One can still start a jupyter notebook server from the container which has been built and access it as long as the appropriate port has been "published" (for example, add ```-p 8080:8080``` to the ```docker run``` command line for port 8080).

```
$ start-notebook.sh
```


## Building a container for a specific version of YARA-X

A specific version of YARA-X can also be specified. For example, the following command allows to build a container for YARA-X v0.3.0:

```
docker build --build-arg yarax_version=v0.3.0 -t yara-x-v0.3.0:v0.3.0 .
```


Then, the container can be run using the following command:

```
docker run -v <path-to-samples>:/tmp/samples -it --rm yara-x-v0.3.0:v0.3.0
```


## How to use YARA-X?

In the container, run ```yr``` from the command line to perform a scan. For example:

```
$ yr scan rules/dummy.yar /tmp/samples/
```


Running ```yr help``` provides you with the help menu of yara-x-cli:

```
$ yr help
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

The Python library for YARA-X is installed in a Python virtual environment located in the ```${username}``` home directory. To use it, activate the ```venv``` virtual environment:


```
$ . venv/bin/activate
$ python -c 'import yara_x; print(dir(yara_x))'
['CompileError', 'Compiler', 'Match', 'Pattern', 'Rule', 'Rules', 'ScanError', 'Scanner', 'TimeoutError', '__all__', '__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__path__', '__spec__', 'compile', 'yara_x']

```

Please refer to the [official documentation](https://virustotal.github.io/yara-x/) for more information about the use of YARA-X.
