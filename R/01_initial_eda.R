# --- 1. Load Libraries ---
# Tidyverse is a collection of R packages for data science (like ggplot2, dplyr)
# Skimr is a package that creates beautiful summary statistics
install.packages("tidyverse")
install.packages("skimr")

library(tidyverse)
library(skimr)


# --- 2. Load Data ---
# Read the CSV file from our "data" folder into a variable called 'telco_data'
telco_data <- read_csv("data/WA_Fn-UseC_-Telco-Customer-Churn.csv")


# --- 3. Initial Inspection ---
# Get a high-level overview of the entire dataset.
# Skimr gives us a rich summary of every column.
skim(telco_data)


# --- 4. Focus on the 'Churn' Variable ---
# Let's see the exact counts of "Yes" and "No" for Churn
telco_data %>%
  count(Churn)


# --- 5. Visualize the Imbalance ---
# A picture is worth a thousand words. Let's create a bar plot.
ggplot(telco_data, aes(x = Churn, fill = Churn)) +
  geom_bar() +
  ggtitle("Customer Churn Distribution") +
  theme_minimal() +
  labs(x = "Did the Customer Churn?", y = "Count")


# --- 6. Calculate Baseline Accuracy ---
# If we made a dumb model that just guessed "No" for every single customer,
# what would its accuracy be? This is our baseline to beat.
telco_data %>%
  count(Churn) %>%
  mutate(Proportion = n / sum(n))

