test_that("Simple expression", {
  expect_equal(fasteval("1+2"), 3)
})

test_that("Simple expressions", {
  expect_equal(fasteval(c("1+2", "3*4")), c(3, 12))
})

test_that("Simple but malformed expressions", {
  expect_no_warning(
    res <- fasteval(c("(0+1)", "(0+1"))
    )
  expect_equal(res, c(1, NA))
})

test_that("Simple but malformed expressions, loudly", {
  expect_warning(
    res <- fasteval(c("(0+1)", "(0+1"), quiet = F)
  )
  expect_equal(res, c(1, NA))
})

test_that("Vectorized strings and repeated vars", {
  expect_equal(
    fasteval(
      c("x+y", "x-y"), 
      list(x = 1, y = 2)
      ), 
    c(3, -1)
    )
})

test_that("Vectorized strings and repeated named args", {
  expect_equal(
    fasteval(
      c("x+y", "x-y"), 
      x = 1, y = 2
      ), 
    c(3, -1)
  )
})

test_that("Vectorized strings and vectorized vars", {
  expect_equal(
    fasteval(
      c("x+y", "x-y"), 
      list(x = 1:2, y = c(1, 100))
      ), 
    c(2, -98)
  )
})

test_that("Vectorized strings and vectorized named args", {
  expect_equal(
    fasteval(
      c("x+y", "x-y"), 
      x = 1:2, 
      y = c(1, 100)
    ), 
    c(2, -98)
  )
})

test_that("Repeated strings and vectorized vars", {
  expect_equal(
    fasteval(
      c("x+y"), 
      list(x = 1:2, y = c(1, 100))
    ), 
    c(2, 102)
  )
})

test_that("Repeated strings and mixed vars", {
  expect_equal(
    fasteval(
      c("x+y"), 
      list(x = 1, y = c(1, 100))
    ), 
    c(2, 101)
  )
})

test_that("Vectorized strings and mixed vars", {
  expect_equal(
    fasteval(
      c("x+y", "y-x"), 
      list(x = 1, y = c(1, 100))
    ), 
    c(2, 99)
  )
})

test_that("Vectorized strings and missing var names", {
  expect_error(
    fasteval(c("x", "-x"), 1)
    )
})

test_that("Vectorized strings and missing a variable", {
  expect_no_warning(
    res <- fasteval(c("x", "-z"), x = 1)
  )
  expect_equal(res, c(1, NA))
})

test_that("Vectorized strings and missing a variable, loudly", {
  expect_warning(
    res <- fasteval(c("x", "-z"), x = 1, quiet = F)
    )
  expect_equal(res, c(1, NA))
})


test_that("Mismatched length strings and vars (string longest, fail at x)", {
  expect_error(
    fasteval(
      c("x+y", "y-x", "x", "y"), 
      list(x = c(1, 2), y = 1)
    )
  )
})

test_that("Mismatched length strings and vars (x longest)", {
  expect_error(
    fasteval(
      c("x+y", "y-x"), 
      list(x = c(1, 2, 3, 4), y = 1)
    )
  )
})

test_that("Mismatched length strings and vars (string longest, fail at y)", {
  expect_error(
    fasteval(
      c("x+y", "y-x", "x", "y"), 
      list(x = 1:4, y = 1:3)
    )
  )
})

test_that("Malformation of quiet flag, recoverable", {
  expect_warning(
    fasteval("(1+2", quiet = "false")
  )
  
  expect_no_warning(
    fasteval("(1+2", quiet = "true")
  )
  
  expect_equal(
    fasteval("(1+2", quiet = "true"), NaN
  )
})

test_that("Malformation of quiet flag, unrecoverable", {
  expect_error(
    fasteval("(1+2)", quiet = "tuer")
  )
})

test_that("Right-to-left exponentiation", {
  expect_equal(fasteval("4^3^2", quiet = F), 4^3^2)
})

test_that("Log is natural log", {
  expect_equal(fasteval("log(e^3)", quiet = F), log(exp(3)))
})

test_that("Many variables", {
  l = setNames(runif(26), LETTERS)
  s = paste(LETTERS, collapse = "+")
  expect_equal(
    fasteval(s, as.list(l)),
    sum(l)
    )
})
