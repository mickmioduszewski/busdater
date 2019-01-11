context("Business period dates")
library(lubridate)
test_that("FY is correct", {
  options(busdaterFYstart = NULL)
  dt <- ymd("2018-01-01", "2018-01-02", "2018-06-30", "2018-07-01",
            "2018-07-02","2018-07-03")
  expect_equal(FY(date = dt, offset_period = 0), c(2018, 2018, 2018, 2019, 2019, 2019))
  expect_equal(FY(date = dt, offset_period = -1), c(2017, 2017, 2017,
                                              2018, 2018, 2018))

  expect_warning(FY(date = dt, offset_period = c(1,2)),
                 paste("package busdater:",
                       "offset_period should be an integer vector of length 1,",
                       "using the first element"))
  expect_error(FY(date = dt, offset_period = c("a")),
               paste("package busdater:",
                     "offset_period must be an integer vector"))
  options(busdaterFYstart = "01-01")
  expect_equal(FY(date = dt, offset_period = 0), c(2018, 2018, 2018, 2018, 2018, 2018))
  expect_equal(FY(date = dt, offset_period = -1), c(2017, 2017, 2017,
                                                    2017, 2017, 2017))
  options(busdaterFYstart = "d-01")
  expect_error(FY(date = dt),
               paste("package busdater:",
                     "optFYstart is in the wrong format"))
  options(busdaterFYstart = c("01-01","02-01"))
  expect_error(FY(date = dt),
               paste("package busdater:",
                     "optFYstart is in the wrong format"))
  options(busdaterFYstart = NULL)
})

test_that("offset_type is correct", {
  expect_warning(period_boundaries(offset_type = c("month", "year")),
                 paste("package busdater:",
                       "offset_type should be a character vector of length 1,",
                       "using the first element"))
  expect_error(period_boundaries(offset_type = c("some")),
               paste("package busdater:",
                     "offset_type must be 'month' or 'year'"))
})

test_that("bus_period is correct", {
  expect_warning(period_boundaries(bus_period = c("FY", "M")),
                 paste("package busdater:",
                       "bus_period should be a character vector of length 1,",
                       "using the first element"))
  expect_error(period_boundaries(bus_period = c("some")),
               paste("package busdater:",
                     "bus_period must be 'FY' or 'CY' or 'M'"))
})

test_that("boundary is correct", {
  expect_warning(period_boundaries(boundary = c("1st day", "last day")),
                 paste("package busdater:",
                       "boundary should be a character vector of length 1,",
                       "using the first element"))
  expect_error(period_boundaries(boundary = c("some")),
               paste("package busdater:",
                     "boundary must be '1st day' or 'last day'"))
})

test_that("offset operation is correct", {
  dtb <- ymd("2020-01-01", "2020-02-15", "2020-02-27", "2020-02-28",
             "2020-02-29", "2020-06-30", "2020-07-01", "2020-12-31")
  expect_equal(offset_dt(date = dtb,
                                offset_period = 0,
                                offset_type = "year"),
               ymd("2020-01-01", "2020-02-15", "2020-02-27", "2020-02-28",
                   "2020-02-29", "2020-06-30", "2020-07-01", "2020-12-31"))
  expect_equal(offset_dt(date = dtb,
                         offset_period = 0,
                         offset_type = "month"),
               ymd("2020-01-01", "2020-02-15", "2020-02-27", "2020-02-28",
                   "2020-02-29", "2020-06-30", "2020-07-01", "2020-12-31"))
  expect_equal(offset_dt(date = dtb,
                         offset_period = 2,
                         offset_type = "year"),
               ymd("2022-01-01", "2022-02-15", "2022-02-27", "2022-02-28",
                   "2022-02-28", "2022-06-30", "2022-07-01", "2022-12-31"))
  expect_equal(offset_dt(date = dtb,
                         offset_period = 2,
                         offset_type = "month"),
               ymd("2020-03-01", "2020-04-15", "2020-04-27", "2020-04-28",
                   "2020-04-29", "2020-08-30", "2020-09-01", "2021-02-28"))
  expect_equal(offset_dt(date = dtb,
                         offset_period = -2,
                         offset_type = "year"),
               ymd("2018-01-01", "2018-02-15", "2018-02-27", "2018-02-28",
                   "2018-02-28", "2018-06-30", "2018-07-01", "2018-12-31"))
  expect_equal(offset_dt(date = dtb,
                         offset_period = -2,
                         offset_type = "month"),
               ymd("2019-11-01", "2019-12-15", "2019-12-27", "2019-12-28",
                   "2019-12-29", "2020-04-30", "2020-05-01", "2020-10-31"))
  expect_equal(offset_dt(date = dtb,
                         offset_period = -1,
                         offset_type = "month"),
               ymd("2019-12-01", "2020-01-15", "2020-01-27", "2020-01-28",
                   "2020-01-29", "2020-05-30", "2020-06-01", "2020-11-30"))
})


test_that("period_boundaries is correct", {
  dtb <- ymd("2020-01-01", "2020-06-30", "2020-07-01", "2020-12-31")
  expect_equal(period_boundaries(date = dtb,
                                 offset_period = 1,
                                 offset_type = "year",
                                 bus_period = "FY",
                                 boundary = "1st day"),
               ymd("2020-07-01", "2020-07-01", "2021-07-01", "2021-07-01"))

  expect_equal(period_boundaries(date = dtb,
                                 bus_period = "FY",
                                 boundary = "1st day"),
               ymd("2019-07-01", "2019-07-01", "2020-07-01", "2020-07-01"))
  expect_equal(period_boundaries(date = dtb,
                                 bus_period = "FY",
                                 boundary = "last day"),
               ymd("2020-06-30", "2020-06-30", "2021-06-30", "2021-06-30"))

  expect_equal(period_boundaries(date = dtb,
                                 bus_period = "CY",
                                 boundary = "1st day"),
               ymd("2020-01-01", "2020-01-01", "2020-01-01", "2020-01-01"))
  expect_equal(period_boundaries(date = dtb,
                                 bus_period = "CY",
                                 boundary = "last day"),
               ymd("2020-12-31", "2020-12-31", "2020-12-31", "2020-12-31"))

  dtb <- ymd("2020-01-01", "2020-02-15", "2020-03-15", "2020-12-31")
  expect_equal(period_boundaries(date = dtb,
                                 bus_period = "M",
                                 boundary = "1st day"),
               ymd("2020-01-01", "2020-02-01", "2020-03-01", "2020-12-01"))
  expect_equal(period_boundaries(date = dtb,
                                 bus_period = "M",
                                 boundary = "last day"),
               ymd("2020-01-31", "2020-02-29", "2020-03-31", "2020-12-31"))

})
