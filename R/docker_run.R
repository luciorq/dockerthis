#' Create and Run Command on a New Docker Container
#'
#' Start a new container to run command line tools inside Linux containers
#'   using Docker Client CLI.
#'
#' @param cmd Character. Command to run.
#'
#' @param ... Character. Additional arguments passed to `cmd`.
#'
#' @param container_name Name of Docker Container.
#'
#' @param image_name Name of Container Image.
#'
#' @param docker_args Character vector. Arguments passed to `docker run` command.
#'
#' @param mount_paths Character vector. Host paths to be mounted in container.
#'
#' @param verbose Logical. Print execution output while running.
#'   Default: `TRUE`.
#'
#' @export
docker_run <- function(cmd,
                       ...,
                       container_name,
                       image_name,
                       docker_args = NULL,
                       mount_paths = NULL,
                       verbose = TRUE) {
  mount_path_arg <- c()
  if (!is.null(mount_paths)) {
    for (mount_path in mount_paths) {
      if (isTRUE(stringr::str_detect(mount_path, pattern = ":"))) {
        mount_temp_vec <- unlist(stringr::str_split(mount_path, pattern = ":"))
        if (!fs::dir_exists(mount_temp_vec[1])) {
          cli::cli_abort(c(
            `x` = "{.path {mount_temp_vec[1]}} do not exist."
          ))
        }
        mount_path_real <- mount_temp_vec[1]
        mount_path_target <- mount_temp_vec[2]
      } else {
        if (!fs::dir_exists(mount_path)) {
          cli::cli_abort(c(
            `x` = "{.path {mount_path}} do not exist."
          ))
        }
        mount_path_real <- mount_path
        mount_path_target <- mount_path_real
      }
      mount_path_arg <- c(
        mount_path_arg,
        paste0("-v=",mount_path_real,":",mount_path_target)
      )
    }
  }
  px_res <- docker_client_cmd(
    "run",
    docker_args,
    mount_path_arg,
    "--name",
    container_name,
    image_name,
    cmd,
    ...,
    verbose = TRUE
  )
  return(invisible(px_res))
}
