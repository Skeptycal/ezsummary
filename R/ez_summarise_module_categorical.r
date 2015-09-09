#' Easy summary for categorical data
#'
#' @description This function provided an easy-to-use way to display simple statistical
#' summary for categorical data. It can be used together with \code{\link[dplyr]{select}}
#' and \code{\link[dplyr]{group_by}}. If the piece of data passed into the function has
#' one/multiple group_by variables, the percentage and count will be calculated within
#' the defined groups.
#'
#' @param tbl The input matrix of data you would like to analyze.
#' @param n n is a True/False switch that controls whether total counts(N) should be included in
#' the output.
#' @param count a T/F switch to control if counts should be included
#' @param p a T/F switch to control if proportion should be included
#' @param P a T/F switch to control if Percentage should be included. This will be a
#' character output
#' @param round.N Rounding number.
#'
#' @return This function will organize all the results into one dataframe. If there are
#' any group_by variables, the first few columns will be them. After these, the varible
#' x will be the one listing all the categorical options in a format like "variable_option".
#' The stats summaries are listed in the last few columns.
#'
#' @examples
#' mtcars %>% group_by(am) %>% select(cyl, gear, carb) %>% ez_summarise_categorical()
#' mtcars %>% select(cyl, gear, carb) %>% ez_summarise_categorical(n=TRUE, round.N = 2)
#'
#' @export


ez_summarise_categorical <- function(tbl, n = FALSE, count = TRUE, p = TRUE, P = FALSE, round.N=3){
  # If the input tbl is a vector, convert it to a 1-D data.frame and set it as a 'tbl' (dplyr).
  if(is.vector(tbl)){
    tbl <- as.tbl(as.data.frame(tbl))
    attributes(tbl)$names <- "unknown"
    warning("ezsummary cannot detect the naming information from an atomic vector. Please try to use something like 'select(mtcars, gear)' to replace mtcars$gear in your code.")
  }

  # Try to obtain grouping and variable information from the input tbl
  group.name <- attributes(tbl)$vars
  var.name <- attributes(tbl)$names
  if (!is.null(group.name)){
    group.name <- as.character(group.name)
    var.name <- var.name[!var.name %in% group.name]
  }
  n.group <- length(group.name)
  n.var <- length(var.name)

  # Set up the calculation formula based on the input.
  options <- c("N = sum(n)", "count = n", "p = round(n / sum(n), round.N)",
               "P = paste0(round(count / sum(n) * 100, round.N), '%')")
  option_names <- c("N","count", "p", "P")
  option_switches <- c(n, count, p, P)
  option_name_switches <- c(n, count, p, P)
  calculation_formula_generator <- function(var.name.1, group.name, options,
                                            option_switches){
    paste0("tbl %>% group_by(",
           paste0(c(group.name, var.name.1), collapse = ", "),
           ") %>% tally %>% rename(variable = ",
           var.name.1,
           ") %>% mutate(variable = paste('",
           var.name.1,
           "', variable, sep = '_'), ",
           paste0(options[option_switches], collapse = ", "),
           ") %>% select(-n)"
    )
  }

  # Perform the calculation and rbind the results into table_export
  table_export <- NULL
  for (i in 1:n.var) {
    table_export <- rbind(table_export,
      eval(parse(text = calculation_formula_generator(var.name[i],group.name, options, option_switches))))
  }

  attributes(table_export)$vars <- attributes(tbl)$vars
  attributes(table_export)$n.group <- n.group
  attributes(table_export)$n.var <- n.var
  attr(table_export, "class") <- c("tbl_df", "tbl", "data.frame")
  attr(table_export, "group_sizes") <- NULL
  attr(table_export, "biggest_group_size") <- NULL
  return(table_export)
}
