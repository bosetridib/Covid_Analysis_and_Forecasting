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

rm(raw_data, case_dates, daily_cases)

# Let us check the plot of the data in original and in differenced form.
plot(daily_cases_df, type = "l")

# There are supposedly THREE WAVES. Hence, the two visible waves can be deduced
# into log-normal and normal distribution. The third wave can be assumed to be
# symmetrically log-normal like the first one.

# ================= The deconstruction can be done as below ================= #

# Under visual sight, the first wave ends somewhere in Feb-Apr.
plot(daily_cases_df[daily_cases_df$date > "2021-01-01",], type = "l")

# Indexing on those months, we set
ind <- ("2021-02-01" < daily_cases_df$date) & (daily_cases_df$date < "2021-04-01")
# And we get the first wave end date as
first_end <- daily_cases_df$date[ind][
  daily_cases_df$cases[ind] == min(daily_cases_df$cases[ind])
]

# Similarly, the second wave ending can also be obtained.
plot(daily_cases_df[daily_cases_df$date > "2021-05-01",], type = "l")

# Seems the second ends between June.
ind <- ("2021-06-01" < daily_cases_df$date) & (daily_cases_df$date < "2021-06-30")

second_end <- daily_cases_df$date[ind][
  daily_cases_df$cases[ind] == min(daily_cases_df$cases[ind])
]

rm(ind)
# Now, we split the data on the basis of first, second and upcoming third wave.
first_wave_df <- daily_cases_df[daily_cases_df$date <= first_end,]

second_wave_df <- daily_cases_df[
  (daily_cases_df$date > first_end) & (daily_cases_df$date <= second_end),
]

third_wave_df <- daily_cases_df[daily_cases_df$date > second_end,]

# ----------------- The first wave log-normal trend ----------------- #

x <- 1:length(first_wave_df$cases)

# The function that returns the residual sum squared for given parameters.
residual_sum_squared <- function(parameter) {
  return(
    sum(
      ( first_wave_df$cases - 
          (parameter[1]*dlnorm(
            x, mean = parameter[2], sd = parameter[3]
          ))
        )^2
    )
  )
}

# The minimization of the RSS would require some initialized elements.