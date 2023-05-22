test_that("Run new container", {
  skip_if_not_local()
  ct_df <- docker_list_containers()
  if (isTRUE("test-123" %in% ct_df$Names)) {
    docker_remove_container("test-123")
  }
  px_res <- docker_run("ls", "-lah", "/", container_name = "test-123", image_name = "ubuntu")
  docker_remove_container("test-123")
  expect_equal(px_res$status, 0)
  expect_true(stringr::str_detect(px_res$stdout, "home"))

  px_res2 <- docker_run(
    "ls", "-lah", "/mnt",
    container_name = "test-123",
    image_name = "ubuntu"
  )

  docker_remove_container("test-123")
})
