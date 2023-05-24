
# dockerthis

<!-- badges: start -->
<!-- badges: end -->

<!-- `dockerthis` is a companion package for `condathis` and `runthis`. -->

**Ship anything, anywhere!**

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

List files inside a Ubuntu 22.04 LTS container

``` r
library(dockerthis)

command_result <- docker_run(
  "ls", "-lah", "/",
  container_name = "dockerthis-ubuntu-test",
  image_name = "ubuntu:22.04"
)

docker_list_containers()

docker_remove_container("dockerthis-ubuntu-test")

command_result
```

Bionformatics example using the Salmon RNA-Seq Aligner pre-built Docker image,
available at [COMBINE-lab/salmon][salmon-ref].

Automatically remove container after execution.

``` r
salmon_result <- docker_run(
  "salmon", "quant", "--help-reads",
  container_name = "dockerthis-salmon-test",
  image_name = "combinelab/salmon:latest",
  docker_args = c(
    "--platform=linux/amd64",
    "--user=",
    "--rm"
  ),
  mount_paths = c(
    getwd()
  )
)

salmon_result
```

Run any command in a conda environment inside a Linux container leveraging [`condathis`][condathis-ref]
integration with `dockerthis`.

``` r
docker_run(
  "micromamba", "create", "-n", "test-env", "-y", "-c", "conda-forge", "-c", "bioconda", "samtools",
  container_name = "condathis-micromamba-samtools",
  image_name = "luciorq/condathis-micromamba:latest",
  docker_args = c(
    "--platform=linux/amd64",
    "--user=dockerthis",
  ),
  mount_paths = c(
    getwd()
  )
)
docker_remove_container("condathis-micromamba-samtools")
```

<!--
``` bash
cd ~/workspaces/temp/condathis-test;
download https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_43/gencode.v43.transcripts.fa.gz;
docker run --platform=linux/amd64 -it --rm -v ${PWD}:${PWD} combinelab/salmon:latest salmon index --transcripts ${PWD}/gencode.v43.transcripts.fa.gz --index ${PWD}/salmon_index --kmerLen 31 --threads 4 --keepDuplicates;
```
-->

## Motivation

`dockerthis` is an R package that promotes reproducibility and portability by running command line tools within isolated Linux containers.
By seamlessly integrating R with Docker, it enables users to create, manage, and execute tools in controlled environments, ensuring consistent execution across different systems and facilitating collaboration.
With `dockerthis`, researchers can confidently share and reproduce their workflows, accelerating scientific discoveries in a wide range of domains.

## Considerations

`dockerthis` don't intend to be a comprehensive Docker Client wrapper.
Additionally `dockerthis` is not intended to be a client communicating directly
with the Docker Engine API, for that one can look at projects like [stevedore][stevedore-ref].

---

[stevedore-ref]: https://github.com/richfitz/stevedore
[condathis-ref]: https://github.com/luciorq/condathis
[salmon-ref]: https://github.com/COMBINE-lab/salmon
