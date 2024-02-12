######################
### create_plots.R ###
######################

# Load the required packages
library(ggplot2)
library(dplyr)
library(viridis)
library(ggthemes)
library(ggtext)
library(sf)
library(stringr)

main <- function() {
    # Load data
    sim_data <- read.csv("input/sim_data.csv")

    # Create plots
    create_hour_of_day_plots(sim_data) 
    create_month_series(sim_data) 
    create_price_map(sim_data)

}

create_hour_of_day_plots <- function(df) {
    grouped_data <- df %>%
        group_by(hour_of_day) %>%
        summarise(mean_price = mean(mean_price),
                            std_price = mean(std_price))
    
    # Plot the grouped data with confidence intervals
    ggplot(grouped_data, aes(x = hour_of_day, y = mean_price)) +
        geom_point(color = "blue", size = 3) +
        geom_errorbar(aes(ymin = mean_price - std_price, ymax = mean_price + std_price), width = 0.05) +
        labs(
            x = "Hour of Day",
            y = "Mean Price ($)") +
        theme_minimal() + 
        theme(plot.title = element_text(size = 20, face = "bold"),
            panel.grid.minor = element_blank(),  # Add transparent minor grid lines
            axis.title = element_text(size = 16),
            axis.text = element_text(size = 14),
            axis.text.x = element_text(hjust = .5),
            axis.ticks = element_line()) +  # Add ticks to the axes
        scale_x_continuous(breaks = 0:23) +
        scale_y_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) 

    # Save the plot as a PNG file
    ggsave("output/mean_price_by_hour_of_day.png", width = 8, height = 6, dpi = 300, bg = "white")
}

create_month_series <- function(df) {
    grouped_data <- df %>%
        mutate(month_year = format(as.Date(date), "%b-%Y")) %>%
        group_by(month_year) %>%
        summarise(mean_price = mean(mean_price),
                            std_price = mean(std_price))
    
    # Plot the grouped data with confidence intervals
    ggplot(grouped_data, aes(x = month_year, y = mean_price)) +
        geom_point(color = "blue", size = 3) +
        geom_errorbar(aes(ymin = mean_price - std_price, ymax = mean_price + std_price), width = 0.05) +
        labs(
            x = "Month-Year",
            y = "Mean Price ($)") +
        theme_minimal() + 
        theme(plot.title = element_text(size = 20, face = "bold"),
            panel.grid.minor = element_blank(),  # Add transparent minor grid lines
            axis.title = element_text(size = 16),
            axis.text = element_text(size = 14),
            axis.text.x = element_text(hjust = .5, angle = 90),
            axis.ticks = element_line()) +  # Add ticks to the axes
        scale_x_discrete(labels = function(x) str_wrap(x, width = 10)) +
        scale_y_continuous(breaks = seq(0, 100, 10), limits = c(0, 100))

    # Save the plot as a PNG file
    ggsave("output/price_by_month.png", width = 8, height = 6, dpi = 300, bg = "white")
}

create_price_map <- function(df) {

    sim_data_sf <- 
        df %>%
        select(zipcode, mean_price, lng, lat) %>%
        # Remove rows with missing values
        na.omit() %>%
        # Convert to simple features object
        st_as_sf(coords = c("lng", "lat"), crs = 4326)

    price_map <- ggplot() +
    geom_sf(data = sim_data_sf, aes(fill = mean_price)) +
    scale_fill_viridis(option = "magma", end = .9) +
    labs(
        fill = "Mean Price ($)"
    ) +
    theme_minimal() +
    theme(plot.title = element_markdown()) +
    theme(legend.position = "bottom")

    # Save the plot as a PNG file
    ggsave("output/mean_price_map.png", width = 10, height = 10, dpi = 300, bg = "white")

}

# Run the main function
main()
