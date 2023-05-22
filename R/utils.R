#' Interact with Docker Engine Client CLI
#'
#' @description
#' Functions for interaction with Docker Images and Containers
#'
#' - `docker_client_cmd()` is the main function to interact with the docker client.
#'
#' - `docker_list_images()` return a data frame with all tagged images
#'   available for to user.
#'
#' - `docker_list_containers()` return a data  frame with all containers and
#'   their state.
#'
#' - `docker_remove_image()` remove Docker image.
#'
#' - `docker_remove_container()` remove Docker container.
#'
#' - `docker_start_container()` start a stopped Docker container.
#'
#' - `docker_stop_container()` stop a running Docker container.
#'
#' @param image_name Character. Name or ID of the Image.
#'
#' @param container_name Character. Name or ID of the Container.
#'
#' @param verbose Logical. Should output from CLI be printed. Default: `TRUE`.
#'
#' @param ... Character. Arguments to be passed to Docker CLI.
#'
#' @export
docker_client_cmd <- function(..., verbose = TRUE) {
  docker_bin_path <- is_docker_available()
  px_res <- processx::run(
    command = docker_bin_path,
    args = c(...),
    echo = verbose,
    echo_cmd = TRUE,
    spinner = TRUE
  )
  return(invisible(px_res))
}

#' @export
#' @rdname docker_client_cmd
docker_list_images <- function() {
  # docker image ls --format "{{json . }}"
  px_res <- docker_client_cmd(
    "image",
    "ls",
    "-a",
    "--format",
    "{{json .}}",
    verbose = FALSE
  )
  if (isTRUE(px_res$status == 0)) {
    res_df <- px_res$stdout |>
      stringr::str_remove("\n$") |>
      stringr::str_split(pattern = "\n", simplify = FALSE) |>
      unlist() |>
      purrr::map_dfr(jsonlite::fromJSON)
    res_df <- res_df[, c("Repository", "Tag", "ID", "CreatedSince", "Size")]
  } else {
    res_df <- tibble::tibble(
      Repository = character(0L),
      Tag = character(0L),
      ID = character(0L),
      CreatedSince = character(0L),
      Size = character(0L)
    )

  }
  return(res_df)
}

#' @export
#' @rdname docker_client_cmd
docker_list_containers <- function() {
  # docker ps -a --format '"{{json . }}"'
  px_res <- docker_client_cmd(
    "ps",
    "-a",
    "--format",
    "{{json .}}",
    verbose = FALSE
  )
  if (isTRUE(px_res$status == 0)) {
    res_df <- px_res$stdout |>
      stringr::str_remove("\n$") |>
      stringr::str_split(pattern = "\n", simplify = FALSE) |>
      unlist() |>
      purrr::map_dfr(jsonlite::fromJSON)
    res_df <- res_df[, c("Names", "Image", "State", "Status", "Ports", "ID")]
  } else {
    res_df <- tibble::tibble(
      Names = character(0L),
      Image = character(0L),
      State = character(0L),
      Status = character(0L),
      Ports = character(0L),
      ID = character(0L)
    )
  }
  return(res_df)
}

#' @export
#' @rdname docker_client_cmd
docker_remove_image <- function(image_name) {
  # docker image rm {image_name}
  px_res <- docker_client_cmd("image", "rm", image_name)
  return(invisible(px_res))
}

#' @export
#' @rdname docker_client_cmd
docker_remove_container <- function(container_name) {
  # docker rm {container_name}
  px_res <- docker_client_cmd("rm", container_name)
  return(invisible(px_res))
}

#' @export
#' @rdname docker_client_cmd
docker_stop_container <- function(container_name) {
  # docker rm {container_name}
  px_res <- docker_client_cmd("stop", container_name)
  return(invisible(px_res))
}

#' @export
#' @rdname docker_client_cmd
docker_start_container <- function(container_name) {
  # docker rm {container_name}
  px_res <- docker_client_cmd("start", container_name)
  return(invisible(px_res))
}
