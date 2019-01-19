"[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)"

# busdater
Business dates for R

Working with business dates can be cumbersome and error prone. 
busdater aims to make it easier, by providing functionality,
to get financial year, calendar year and month calculations.
It returns start and end of the business periods.

Jurisditions and organisations observe different start and end of financial year.
optFYstart parameter is string in the format of "MM-DD" representing the start
of financial year, e.g. "01-01" for 1st of January or "07-01" for 1st of July. The default is taken from options and is "07-01" if not present.

This package caters for financial years that have a fixed start date.
It does not cater for moving dates e.g. last Friday of September.

The package has 2 functions:

* `FY` to return the financial (fiscal) year as integers
* `period_boundaries` to return start and end of a month and start and end of financial years

Enjoy!
