#' Run Command on a Running Docker Container
#'
#' @inheritParams docker_run
#'
#' @export
docker_exec <- function(cmd, ..., container_name, verbose = TRUE) {
  px_res <- docker_client_cmd(
    "exec",
    container_name,
    cmd,
    ...,
    verbose = verbose
  )
  return(invisible(px_res))
}
