# EN Data Archive [(RO)](./docs/RO.md)
This is an archive of the [data published by the Romanian Ministry of Education](http://static.evaluare.edu.ro)
regarding the results of a national exam. I have created this archive because data from previous years is not available.

# Usage
The csv data is located in the `data` directory.
```shell
$ git clone https://github.com/Nikoof/en-data && cd en-data
$ tree data
data
├── 2019.csv
├── 2020.csv
├── 2021.csv
├── 2022.csv
└── ...
```
Alternatively, it can be downloaded directly from the [releases page](https://github.com/Nikoof/en-data/releases/latest).

## Script
The shell script used to compile the data is also available in this repo.

Run it directly
```shell
$ chmod u+x en-data.sh
$ ./en-data -h
```

Or use nix
```shell
$ nix run github:Nikoof/en-data -- -h
```

## Requirements
- curl
- jq
