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
  px_res <- docker_client_cmd(
    "run",
    docker_args,
    mount_paths,
    "--name",
    container_name,
    image_name,
    cmd,
    ...,
    verbose = TRUE
  )
  return(invisible(px_res))
}
