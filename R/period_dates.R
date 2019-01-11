#' @details
#' Working with business dates can be cumbersome and error prone.
#' This package aims to make it easier, by providing functionality,
#' to get financial year, calendar year and month calculations.
#' It returns start and end of the business periods.
#'
#' \describe{
#'   \item{\code{\link{FY}}}{Get financial year, possibly with an offset priod}
#'   \item{\code{\link{period_boundaries}}}{Get date's business period boundary.}
#' }
#' @keywords internal
"_PACKAGE"



#' Get a financial year.
#'
#' \code{FY()} returns the current financial year.
#' It also returns financial year based on parameter dates, or financial year
#' based on a parameter dates and offset_period in years.
#'
#' @param date A date vector for which financial year is required.
#' Date must be POSIXct or POSIXlt or Date objects.
#' @param offset_period A positive or negative number  coercible to
#' integer to shift the year by,
#' e.g. in the case of \code{FY}, -1 for previous year, 1 for next year. More
#' generally in \code{page_boundaries} function it is a number of periods of
#' a specified period type
#' @param optFYstart A string in the format of "MM-DD" representing the start
#' of financial year, e.g. "01-01" for 1st of January or "07-01" for 1st of July.
#' This package caters for financial years that have a fixed start date.
#' It does not cater for moving dates e.g. last Friday of September.
#' @return An integer vector containing the current financial year if offset
#' \code{offset_period} is 0, otherwise add the offset \code{offset_period}
#' in years.
#' @examples
#' FY() ## return the current financial year as integer
#'
#' dt <- as.Date(c("01-01-2018", "15-12-2017"), "%d-%m-%Y")
#' FY(date = dt[1])
#' FY(date = dt)
#'
#' FY(offset_period = 1) ## return the next financial year as integer
#' FY(date = dt[1], offset_period = 1)
#' FY(date = dt, offset_period = 1)
#'
#' FY(offset_period=-1) ## return the previous financial year as integer
#' FY(date = dt[1], offset_period = -1)
#' FY(date = dt, offset_period = -1)
#'
#'
#' \dontrun{
#' FY("a") ## will fail because dates are expected.
#' }
#' @family business date functions
#' @export
#' @importFrom lubridate month
#' @importFrom lubridate year
FY <- function(date = Sys.Date(),
               offset_period = 0,
               optFYstart = getOption("busdaterFYstart", default = "07-01")) {
  tmp <- check_param_offset_period(offset_period)
  x <- check_param_optFYstart(optFYstart)
  y <- year(date)
  optFYstart_dt <- ymd(paste0(y, "-", x$MM, "-", x$DD))
  n <- length(date)
  ret <- ifelse(rep.int(x$DD,n) == 1 & rep.int(x$MM,n) == 1, y + offset_period,
                ifelse(date < optFYstart_dt, y + offset_period,
                       y + 1 + offset_period))
  as.integer(ret)
}
#' Get date's business period boundary.
#'
#' The \code{period_boundaries} will shift the input \code{date} vector by
#' a number of months and years i.e. \code{date + offset_period * offset_type}.
#' It will handle the typical business date arithmetic.
#' @inheritParams FY
#' @param offset_type It is either \code{"month"} or \code{"year"}
#' @param  bus_period It is either \code{"FY"} for financial year,
#' \code{"CE"} for calendar year or \code{"M"} for month
#' @param boundary Either \code{"1st day"} for the first day of the period or
#' \code{"last day"} for the end of the period.
#' @return A vector of dates.
#' @examples
#' # the 1st day of the current financial year
#' period_boundaries()
#'
#' # the last day of the current financial year
#' period_boundaries(boundary = "last day")
#'
#' # the last day of the last calendar year
#' period_boundaries(offset_period = -1, bus_period = "CY", boundary = "last day")
#'
#' # the last day of month 14 months from now
#' period_boundaries(offset_period = 14, offset_type = "month",
#'                   bus_period = "M", boundary = "last day")
#'
#' # The first day of finacial years for dates 3 months before the given dates
#' period_boundaries(as.Date(c("02/27/1992", "09/28/2022"), "%m/%d/%Y"),
#'                   offset_period = -3, offset_type = "month",
#'                   bus_period = "FY", boundary = "1st day")
#'
#' @family business date functions
#' @export
#' @importFrom lubridate add_with_rollback
#' @importFrom lubridate years
#' @importFrom lubridate period
#' @importFrom lubridate ymd
#' @importFrom lubridate floor_date
#' @importFrom lubridate ceiling_date
period_boundaries <- function(date = Sys.Date(),
                              offset_period = 0,
                              offset_type = "year",
                              bus_period = "FY",
                              boundary = "1st day",
                              optFYstart = getOption("busdaterFYstart",
                                                     default = "07-01")) {
  offset_period <- check_param_offset_period(offset_period)
  offset_type <- check_param_offset_type(offset_type)
  bus_period <- check_param_bus_period(bus_period)
  boundary <- check_param_boundary(boundary)

  dt_off <- offset_dt(date = date, offset_period = offset_period,
                       offset_type = offset_type)
  rt <- NULL

  if (bus_period == "FY") {
    fy <- FY(dt_off, optFYstart = optFYstart)
    if (boundary == "1st day") {
      rt <- ymd(paste0(fy-1,optFYstart))
    } else {
      rt <- ymd(paste0(fy,optFYstart)) - 1}
  } else {
    if (bus_period == "CY") {
      unt <- "year"
    } else {
        unt <- "month"}
    if (boundary == "1st day") {

      rt <- floor_date(dt_off, unit = unt)
    } else {
      rt <- ceiling_date(dt_off, unit = unt) - 1}
  }
  return(rt)
}

offset_dt <- function(date, offset_period, offset_type) {
  offset_period <- check_param_offset_period(offset_period)
  offset_type <- check_param_offset_type(offset_type)

  off <- period(offset_period,offset_type)
  rt <- add_with_rollback(date, off)
  return(rt)
}

check_param_optFYstart <- function(x) {
  optFYstartL <- strsplit(x, "-")
  if (length(optFYstartL) != 1 || length(optFYstartL[[1]]) != 2) {
    stop(paste("package busdater:",
               "optFYstart is in the wrong format"))
  }
  optFYstartMM <- suppressWarnings(as.integer(optFYstartL[[1]][1]))
  optFYstartDD <- suppressWarnings(as.integer(optFYstartL[[1]][2]))
  if (is.na(optFYstartMM) || is.na(optFYstartDD)) {
    stop(paste("package busdater:",
               "optFYstart is in the wrong format"))
  }
  list(DD = optFYstartDD, MM = optFYstartMM)
}

check_param_offset_period <- function(offset_period) {
  if (length(offset_period) != 1) {
    warning(paste("package busdater:",
               "offset_period should be an integer vector of length 1,",
               "using the first element"))
  }
  temp <- suppressWarnings(as.integer(offset_period[1]))
  if (is.na(temp)) {
    stop(paste("package busdater:",
               "offset_period must be an integer vector"))
  }
  return(offset_period[1])
}
check_param_offset_type <- function(offset_type) {
  if (length(offset_type) != 1) {
    warning(paste("package busdater:",
                  "offset_type should be a character vector of length 1,",
                  "using the first element"))
  }
  if (!(offset_type[1] %in% c("month", "year"))) {
    stop(paste("package busdater:",
               "offset_type must be 'month' or 'year'"))
  }
  return(offset_type[1])
}
check_param_bus_period <- function(bus_period) {
  if (length(bus_period) != 1) {
    warning(paste("package busdater:",
                  "bus_period should be a character vector of length 1,",
                  "using the first element"))
  }
  if (!(bus_period[1] %in% c('FY', 'CY', 'M'))) {
    stop(paste("package busdater:",
               "bus_period must be 'FY' or 'CY' or 'M'"))
  }
  return(bus_period[1])
}
check_param_boundary <- function(boundary) {
  if (length(boundary) != 1) {
    warning(paste("package busdater:",
                  "boundary should be a character vector of length 1,",
                  "using the first element"))
  }
  if (!(boundary[1] %in% c('1st day', 'last day'))) {
    stop(paste("package busdater:",
               "boundary must be '1st day' or 'last day'"))
  }
  return(boundary[1])
}
