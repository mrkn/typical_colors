# Typical color extraction example

## Usage

### typical_colors.jl

```
$ julia typical_colors.jl --help
usage: typical_colors.jl [-k K] [-h] filenames...

This program extract typical colors from the given images

positional arguments:
  filenames   an image filenames

optional arguments:
  -k K        the number of typical colors to be extracted (type:
              Int64, default: 3)
  -h, --help  show this help message and exit
```

### Sinatra app

```
$ bundle install
$ bundle exec rackup
```

