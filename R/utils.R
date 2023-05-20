#' Interact with Docker Engine Daemon
#'
#' Functions for interaction with Docker Images and Containers

#' @export
docker_list_images <- function() {
  # docker image ls --format "{{json . }}"
  docker_bin_path <- is_docker_available()
  px_res <- processx::run(
    command = docker_bin_path,
    args = c(
      "image",
      "ls",
      "-a",
      "--format",
      "{{json .}}"
    ),
    echo = FALSE,
    spinner = TRUE
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
docker_list_containers <- function() {
  # docker ps -a --format '"{{json . }}"'
  docker_bin_path <- is_docker_available()
  px_res <- processx::run(
    command = docker_bin_path,
    args = c(
      "ps",
      "-a",
      "--format",
      "{{json .}}"
    ),
    echo = FALSE,
    spinner = TRUE
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

#' Remove Docker Image
#' @param image_name Name or ID of the Image.
#' @export
docker_remove_image <- function(image_name) {
  # docker image rm {image_name}
  docker_bin_path <- is_docker_available()
  px_res <- processx::run(
    command = docker_bin_path,
    args = c(
      "image",
      "rm",
      image_name
    ),
    echo = FALSE,
    spinner = TRUE
  )
}

#' Remove Docker Container
#'
#' Container needs to be stopped before removing
#'
#' @param container_name Name or ID of the Container.
#' @export
docker_remove_container <- function(container_name) {
  # docker rm {image_name}
  docker_bin_path <- is_docker_available()
  px_res <- processx::run(
    command = docker_bin_path,
    args = c(
      "rm",
      container_name
    ),
    echo = FALSE,
    spinner = TRUE
  )
}
