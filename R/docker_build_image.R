#' Build Docker Container Image
#'
#' Built Docker Image given a Dockerfile.
#'
#' @param dockerfile_path Chracter. Path to Dockerfile.
#'
#' @param image_name Character. Name of the Image to be created.
#'
#' @param force Logical. Should image be removed before new build.
#'   Default FALSE.
#'
#' @param platform_arg Character. Platform string to be used, by default it
#'   will use the one configured by Docker, usually Linux with the same
#'   CPU architecture the same as the system,
#'   import options are `c("linux/amd64", "linux/arm64", "linux/arm/v7")`.
#'   Default NULL.
#'
#' @export
docker_build_image <- function(dockerfile_path,
                               image_name,
                               force = FALSE,
                               platform_arg = NULL) {
  if (any(is.na(dockerfile_path), is.null(dockerfile_path), dockerfile_path == "")) {
    cli::cli_abort(c(
      `x` = "{.field dockerfile_path} needs to be a character string existing of a file path."
    ))
  }
  if (any(is.na(image_name), is.null(image_name), image_name == "")) {
    cli::cli_abort(c(
      `x` = "{.field image_name} needs to be a character string."
    ))
  }
  if (!fs::file_exists(dockerfile_path)) {
    cli::cli_abort(c(
      `x` = "Dockerfile in {.path {dockerfile_path}} don't exist."
    ))
  }
  if (isTRUE(force)) {
    image_df <- docker_list_images()
    repository_name <- stringr::str_remove(image_name, ":.*$")
    if (isTRUE(repository_name %in% image_df$Repository)) {
      docker_remove_image(image_name = image_name)
    }
  }
  if (!is.null(platform_arg)) {
    platform_arg <- paste0("--platform=", platform_arg)
  }
  context_path <- fs::path_real(getwd())
  px_res <- docker_client_cmd(
    "buildx",
    "build",
    platform_arg, # "linux/amd64,linux/arm64,linux/arm/v7",
    "--file",
    dockerfile_path,
    "--tag",
    image_name,
    context_path,
    verbose = TRUE
  )
  return(invisible(px_res))
}
