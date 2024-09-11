#' Is Docker Client CLI available
#'
#' Test if Docker CLI is available on PATH.
#'
#' @export
is_docker_available <- function() {
  docker_bin_path <- Sys.which("docker")
  if (isTRUE(!nzchar(docker_bin_path) && Sys.info()["sysname"] == "Windows")) {
    docker_bin_path <- Sys.which("docker.exe")
  }
  if (isFALSE(fs::file_exists(docker_bin_path))) {
    cli::cli_abort(c(
      `x` = "{.pkg docker} client command line interface is not available.",
      `!` = "Docker can be installed from: {.url https://docs.docker.com/engine/install/}."
    ))
  }
  docker_bin_path <- fs::path(docker_bin_path)
  return(docker_bin_path)
}
