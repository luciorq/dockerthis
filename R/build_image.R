#' Build Micromamba Container Image
#' @export
build_micromamba_image <- function(dockerfile_path = NULL,
                                   image_name = "umamba-dockerthis:latest") {
  build_docker_image(dockerfile_path = NULL, image_name = image_name)
}

#' Build Docker Container Image
#' @export
build_docker_image <- function(dockerfile_path = NULL,
                               image_name) {

  docker_bin_path <- is_docker_available()

  if (!nzchar(image_name)) {
    cli::cli_abort(c(
      `x` = "{.var image_name} needs to be a character string."
    ))
  }

  if (is.null(dockerfile_path)) {
     dockerfile_path <- fs::path(
      fs::path_package("dockerthis", "inst", "build"),
      "micromamba",
      ext = "dockerfile"
    )
  }

  if (!fs::file_exists(dockerfile_path)) {
    cli::cli_abort(c(
      `x` = "Dockerfile in {.path {dockerfile_path}} don't exist."
    ))
  }

  context_path <- fs::path_real(getwd())

  px_res <- processx::run(
    command = docker_bin_path,
    args = c(
      "buildx",
      "build",
      "--platform",
      "linux/amd64", # "linux/amd64,linux/arm64,linux/arm/v7",
      "--file",
      dockerfile_path,
      "--tag",
      image_name,
      context_path
    ),
    echo = TRUE,
    spinner = TRUE
  )

  return(invisible(px_res))
}
