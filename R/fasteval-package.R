#' fasteval: Fast evaluation of mathematical expressions.
#'
#' This package quickly converts strings like "1+2" to a value of 3, 
#' including variable interpolation. The only R function, 
#' \code{\link{fasteval}}, is a thin wrapper around the C library 
#' \code{{tinyexpr}}. It is generally 20-150 times faster than 
#' looping over a vector such as 
#' \code{lapply(x, function(s) eval(parse(text = s)))}.
#' 
#' @note 
#' Unlike the original C library, exponentiation precedence takes place from
#' right to left to match the behavior in R. Additionally, \code{"log"}
#' refers to the natural log, as it does in R.
#' 
#' @references 
#' Van Winkle, Lewis. C Library, \code{{tinyexpr}}. \url{https://github.com/codeplea/tinyexpr}
#' 
#'
#' @docType package
#' @name fasteval-package
NULL