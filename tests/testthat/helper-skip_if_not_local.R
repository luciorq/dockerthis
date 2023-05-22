skip_if_not_local <- function() {
  if (!isTRUE(Sys.info()["nodename"] == "sigma.local" &
              Sys.info()["user"] == "luciorq")) {
    skip("Not run without Docker Client CLI.")
  } else {
    return(invisible())
  }
}
