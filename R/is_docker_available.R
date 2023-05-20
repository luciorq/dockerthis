#' @export
is_docker_available <- function() {
  docker_bin_path <- Sys.which("docker")

  if (isTRUE(!nzchar(docker_bin_path) & Sys.info()["sysname"] == "Windows")) {
    docker_bin_path <- Sys.which("docker.exe")
  }

  if (!fs::file_exists(docker_bin_path)) {
    cli::cli_abort(c(
      `x` = "{.var docker} command line interface is not available.",
      `!` = "Docker can be installed from: {.url https://docs.docker.com/engine/install/}"
    ))
  }
  return(docker_bin_path)
}
