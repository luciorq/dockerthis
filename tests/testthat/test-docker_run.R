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

  temp_path <- fs::dir_create(
    fs::path_temp()
  )
  temp_file <- fs::path(temp_path, "test", ext = "txt")
  fs::file_create(temp_file)

  px_res2 <- docker_run(
    "ls", "-lah", temp_path,
    container_name = "test-123",
    image_name = "ubuntu",
    mount_paths = paste0("-v=",temp_path,":",temp_file)
  )
  expect_true(fs::file_exists(temp_file))
  if (fs::file_exists(temp_file)) {
    fs::file_delete(temp_file)
  }
  docker_remove_container("test-123")
  expect_true(stringr::str_detect(px_res2$stdout, "test.txt"))
})
