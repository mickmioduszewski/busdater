% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/period_dates.R
\name{get_fy}
\alias{get_fy}
\title{Get a financial year.}
\usage{
get_fy(
  date = Sys.Date(),
  offset_period = 0,
  opt_fy_start = getOption("busdaterFYstart", default = "07-01")
)
}
\arguments{
\item{date}{A date vector for which financial year is required.
Date must be POSIXct or POSIXlt or Date objects.}

\item{offset_period}{A positive or negative number  coercible to
integer to shift the year by,
e.g. in the case of \code{get_fy}, -1 for previous year, 1 for next year.
More generally in \code{page_boundaries} function it is a number of periods
of a specified period type}

\item{opt_fy_start}{A string in the format of "MM-DD" representing the start
of financial year, e.g. "01-01" for 1st of January or "07-01"
for 1st of July.
This package caters for financial years that have a fixed start date.
It does not cater for moving dates e.g. last Friday of September.}
}
\value{
An integer vector containing the current financial year if offset
\code{offset_period} is 0, otherwise add the offset \code{offset_period}
in years.
}
\description{
\code{get_fy()} returns the current financial (fiscal) year.
It also returns financial year based on parameter dates, or financial year
based on a parameter dates and offset_period in years.
}
\examples{
get_fy() ## return the current financial year as integer

dt <- as.Date(c("01-01-2018", "15-12-2017"), "\%d-\%m-\%Y")
get_fy(date = dt[1])
get_fy(date = dt)

get_fy(offset_period = 1) ## return the next financial year as integer
get_fy(date = dt[1], offset_period = 1)
get_fy(date = dt, offset_period = 1)

get_fy(offset_period=-1) ## return the previous financial year as integer
get_fy(date = dt[1], offset_period = -1)
get_fy(date = dt, offset_period = -1)


\dontrun{
get_fy("a") ## will fail because dates are expected.
}
}
\seealso{
Other business date functions: 
\code{\link{FY}()},
\code{\link{get_boundary}()},
\code{\link{period_boundaries}()}
}
\concept{business date functions}
