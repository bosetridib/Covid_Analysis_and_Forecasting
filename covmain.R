# Read data from the WHO url
raw_data <- read.csv("https://covid19.who.int/WHO-COVID-19-global-data.csv")
# or from the downloaded csv from the url
# raw_data <- read.csv("WHO-COVID-19-global-data.csv")
View(raw_data)

# To get the worldwide daily cases, the date should be uniquely obtained.
case_dates <- sort(unique(raw_data$Date_reported))

# The daily cases worldwide dataframe would be build as below.
daily_cases <- NULL
for (i in 1:length(case_dates)) {
  daily_cases[i] <- sum(
    raw_data$New_cases[raw_data$Date_reported == case_dates[i]], na.rm = TRUE
  )
}

# The vector above is converted to dataframe wih dates as below.
daily_cases_df <- data.frame('date' = as.Date(case_dates) , 'cases' = daily_cases)

# Let us check the plot of the data
plot(daily_cases_df, type = "l")

# There are supposedly three waves.