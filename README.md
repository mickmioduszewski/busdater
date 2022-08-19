[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://choosealicense.com/licenses/mit/)
[![Build Status](https://travis-ci.org/mickmioduszewski/busdater.svg?branch=master)](https://travis-ci.org/mickmioduszewski/busdater)
[![codecov](https://codecov.io/gh/mickmioduszewski/busdater/branch/master/graph/badge.svg)](https://codecov.io/gh/mickmioduszewski/busdater)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/busdater)](https://cran.r-project.org/package=busdater)
[![CRAN_latest_release_date](https://www.r-pkg.org/badges/last-release/busdater)](https://cran.r-project.org/package=busdater)
[![metacran downloads](https://cranlogs.r-pkg.org/badges/grand-total/busdater)](https://cran.r-project.org/package=busdater)
![](https://img.shields.io/github/languages/top/mickmioduszewski/busdater.svg)
![](https://img.shields.io/github/issues/mickmioduszewski/busdater.svg)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/2468/badge)](https://bestpractices.coreinfrastructure.org/projects/2468)



# busdater
Business dates for R

Working with business dates can be cumbersome and error prone. 
busdater aims to make it easier, by providing functionality,
to get financial year, calendar year and month calculations.
It returns start and end of the business periods.

Jurisdictions and organisations observe different start and end of financial year.
opt_fy_start parameter is string in the format of "MM-DD" representing the start
of financial year, e.g. "01-01" for 1st of January or "07-01" for 1st of July. The default is taken from options and is "07-01" if not present.

This package caters for financial years that have a fixed start date.
It does not cater for moving dates e.g. last Friday of September.

The package has 4 functions (2 deprecated):

* `get_fy` to return the financial (fiscal) year as integers
* `get_boundary` to return start and end of a month and start and end of financial years
* `FY` deprecated and same as `get_fy`
* `period_boundaries` deprecated and same as `get_boundary`

Enjoy!
