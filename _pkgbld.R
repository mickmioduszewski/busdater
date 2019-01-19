# Checks 
lintr::lint_package()
devtools::spell_check()
# Continuous integration on Travis, 3 R versions & includes codecov.io 




# #### Build protocol ####

# Generate documents with pkgdown
pkgdown::build_site()

# Build the package by running in shell
# R CMD BUILD busdater

# Check build package by running in shell
# R CMD BUILD --as-cran busdater_0.2.0.tar.gz


