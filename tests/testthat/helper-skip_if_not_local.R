skip_if_not_local <- function() {
  if (isFALSE(Sys.info()["nodename"] == "sigma.local" &&
              Sys.info()["user"] == "luciorq")) {
    testthat::skip("Not run without Docker Client CLI.")
  } else {
    return(invisible())
  }
}
