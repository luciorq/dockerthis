
# dockerthis

<!-- badges: start -->
<!-- badges: end -->

`dockerthis` is a companion package for `condathis` and `runthis`.

The main goal of `dockerthis` is to allow command line applications that don't
package nativelly on unsupported Operational Systems (OS) or CPU architectures 
(e.g. Arm64) to run inside a Linux Docker container.

The main function in this package will try to run the required command line tool in a 
Ubuntu-based Linux using `micromamba` to install the required packages, but you can
also provide additional Docker Images to for commonly available software.

The development team has a special focus on allowing Bioinformatics.

## Installation

You can install the development version of `dockerthis` using:

``` r
remotes::install_github("luciorq/dockerthis")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(dockerthis)
dockerthis::run("samtools", "--version")
```

## Considerations

`dockerthis` don't intend to be a comprehensive Docker Client wrapper.
Additionally `dockerthis` is not intended to be a client communicating directly
with the Docker Engine API, for that one can look at projects like [stevedore][stevedore-ref].

---

[stevedore-ref]: https://github.com/richfitz/stevedore
