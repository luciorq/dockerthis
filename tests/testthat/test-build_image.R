test_that("Missing dockerfile", {
  expect_error(
    object = docker_build_image(
      dockerfile_path = NULL,
      image_name = "mockname-image",
      force = FALSE,
      platform_arg = NULL
    ),
    regexp = "needs to be a character string existing of a file path"
  )
})

test_that("Missing image name", {
  expect_error(
    object = docker_build_image(
      dockerfile_path = fs::path_package(
        "dockerthis", "dockerfiles", "base", ext = "dockerfile"
      ),
      image_name = "",
      force = FALSE,
      platform_arg = NULL
    ),
    regexp = "needs to be a character string"
  )
})

test_that("Base image is built correcly", {
  skip_if_not_local()
  repo_str <- "dockerthis-base"
  img_str <- paste0(repo_str, ":latest")
  ct_str <- "dockerthis-base-test"

  px_res <- docker_build_image(
    dockerfile_path = fs::path_package(
      "dockerthis", "dockerfiles", "base", ext = "dockerfile"
    ),
    image_name = img_str,
    force = TRUE,
    platform_arg = NULL
  )

  expect_equal(px_res$status, 0)

  images_df <- docker_list_images()
  expect_true(repo_str %in% images_df$Repository)

  run_res <- docker_run(
    cmd = "whoami",
    docker_args = c(
      "--user=dockerthis"
    ),
    container_name = ct_str,
    image_name = img_str
  )

  expect_equal(run_res$status, 0)

  expect_equal(run_res$stdout, "dockerthis\n")

  container_df <- docker_list_containers()
  expect_true(ct_str %in% container_df$Names)

  docker_remove_container(container_name = ct_str)

  docker_remove_image(image_name = img_str)

  images_df <- docker_list_images()
  expect_false(repo_str %in% images_df$Repository)

  container_df <- docker_list_containers()
  expect_false(ct_str %in% container_df$Names)
})
