#######################
### simulate_data.R ###
#######################

# Load packages
library(tidyverse)
library(data.table)
library(lubridate)
library(zipcodeR)

# Set seed
set.seed(1234)

# Simulate a data set with the following characteristics:
# 10000 observations
# zipcode: 10000 randomly drawn from the zip codes in California
# date: 10000 dates between 2023-01-01 and 2023-12-31
# hour_of_day: 10000 values between 0 and 23
# policy: random binary variable
# traffic_index: 10000 values between 0 and 100
# cars_requested: 10000 values between 0 and 100
# cars_available: 10000 values between 0 and 100
# mean_price: 10000 values between 0 and 100
# std_price: 10000 values between 0 and 100

main <- function(){

CA_zip_codes <- zipcodeR::search_state("CA")

# Simulate data
sim_data <- tibble(
    zipcode = sample(CA_zip_codes$zipcode, 10000, replace = TRUE),
    date = as.Date(sample(seq(as.Date("2023-01-01"), as.Date("2023-12-31"), by = "day"), 10000, replace = TRUE)),
    hour_of_day = sample(0:23, 10000, replace = TRUE),
    policy_active = rbinom(10000, 1, prob = 0.7), # Assume 70% of the time policy is active
    traffic_index = rnorm(10000, mean = 50, sd = 15), # Assume traffic index is normally distributed
    cars_requested = rpois(10000, lambda = 20), # Assume number of cars requested follows a Poisson distribution
    cars_available = pmax(rpois(10000, lambda = 30), cars_requested), # Assume number of cars available is always at least as much as requested
    mean_price = rnorm(10000, mean = 50, sd = 10), # Assume mean price is normally distributed
    std_price = rnorm(10000, mean = 5, sd = 2) # Assume standard deviation of price is normally distributed
)

# Add latitude and longitude
sim_data <- sim_data %>%
    left_join(CA_zip_codes, by = "zipcode")

# Save data
write.csv(sim_data, file = "output/sim_data.csv")

}

# Execute main function
main()
