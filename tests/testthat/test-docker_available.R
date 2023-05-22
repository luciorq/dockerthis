test_that("Docker Available", {
  skip_if_not_local()
  docker_bin_path <- is_docker_available()
  expect_true(stringr::str_detect(docker_bin_path, "docker"))
})

test_that("Missing Docker CLI", {
  withr::local_path(new = list(), action = "replace")
  expect_error(
    object = is_docker_available(),
    regexp = "client command line interface is not available"
  )
})
