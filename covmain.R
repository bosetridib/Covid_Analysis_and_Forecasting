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

# Under visual sight, the first wave ends somewhere in Feb-Mar.
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
first_wave_df <- daily_cases_df[daily_cases_df$date < first_end,]

second_wave_df <- daily_cases_df[
  (daily_cases_df$date >= first_end) & (daily_cases_df$date <= second_end),
]

third_wave_df <- daily_cases_df[daily_cases_df$date > second_end,]

# ----------------- The first wave: log-normal trend ----------------- #

x1 <- 1:length(first_wave_df$cases)

# The function that returns the residual sum squared for given parameters.
residual_sum_squared_first <- function(parameter) {
  return(
    sum(
      (
        first_wave_df$cases -
          (
            parameter[1]*dlnorm(
              (parameter[4] - x1), # Read Flipped-lnorm for the 4th parameter
              mean = parameter[2], sd = parameter[3]
            )
          )
      )^2
    )
  )
}

# The minimization of the RSS would be done with different iterations of the
# optim fucntion. The problem is that the optim function's efficiency depends
# on the initialized values. This is why we use different iterations wrt
# different parameters. The i, j and k are the different parameters in the
# RSS function, respectively.

val1 <- NULL

for (shift in (length(x)-30) : (length(x)+30)) {
  for (amp in seq(10^7,3*10^8, by=10^7)){
    for (meanval in seq(2.5,7.5, by=0.5)){
      for (stddev in seq(0.10,1.10, by=0.05)){
        val1 <- rbind(
          val1,
          c(
            optim(c(amp,meanval,stddev,shift), residual_sum_squared_first)$par,
            optim(c(amp,meanval,stddev,shift), residual_sum_squared_first)$value
          )
        )
      }
    }
  }
}

# The last column of the val matrix is the minimized RSS in each iteration. Of
# all the iterations, the parameters that minimize the RSS function 'overall':
est_parameters_first <- val1[val1[,5] == min(val1[,5]),1:4]
# est_parameters_first <- c(1.178663e+08, 4.931919e+00, 6.258448e-01, 4.560777e+02)

# The plot of the values would be as below.
plot(first_wave_df$date, first_wave_df$cases, type = "l")
lines(
  first_wave_df$date,
  est_parameters_first[1]*(
    dlnorm(
      est_parameters_first[4] - x1,
      mean = est_parameters_first[2], sd=est_parameters_first[3]
    )
  )
)


# -------------------- The second wave: normal trend -------------------- #

x2 <- 1:length(second_wave_df$cases)

# The function that returns the residual sum squared for given parameters.
residual_sum_squared_second <- function(parameter) {
  return(
    sum(
      (
        second_wave_df$cases -
          parameter[4] - # Read Shifted-norm for the 4th parameter
            (parameter[1]*dnorm(
              x2,
              mean = parameter[2], sd = parameter[3]
            )
          )
      )^2
    )
  )
}

val2 <- NULL

for (shift in seq(2*10^5, 4*10^5, by=5*10^4)) {
  for (amp in seq(10^6,10*10^7, by=5*10^6)){
    for (meanval in seq(60,70, by=5*1)){
      for (stddev in seq(10,100, by=10)){
        val2 <- rbind(
          val2,
          c(
            optim(c(amp,meanval,stddev,shift), residual_sum_squared_second)$par,
            optim(c(amp,meanval,stddev,shift), residual_sum_squared_second)$value
          )
        )
      }
    }
  }
}

est_parameters_second <- val2[val2[,5] == min(val2[,5]),1:4]
# est_parameters_second <- c(2.545835e+07, 6.861743e+01, 2.188808e+01, 3.502473e+05)

plot(second_wave_df$date, second_wave_df$cases, type = "l")
lines(
  second_wave_df$date,
  est_parameters_second[4] + est_parameters_second[1]*(
    dnorm(
      x2,
      mean = est_parameters_second[2], sd=est_parameters_second[3]
    )
  )
)


# ----------------- The third wave: log-normal trend ----------------- #

x3 <- 1:length(third_wave_df$cases)

# The function that returns the residual sum squared for given parameters.
residual_sum_squared_third <- function(parameter) {
  return(
    sum(
      (
        third_wave_df$cases -
          (
            parameter[1]*dlnorm(
              (x3 + parameter[4]), # Non Flipped-lnorm, 4th parameter only shifts horizontally
              mean = parameter[2], sd = parameter[3]
            )
          )
      )^2
    )
  )
}

val3 <- NULL

for (shift in seq(-30,30, by=5)) {
  for (amp in seq(10^7,4*10^8, by=5*10^7)){
    for (meanval in seq(2.5,7.5, by=0.5)){
      for (stddev in seq(0.10,1.10, by=0.10)){
        val3 <- rbind(
          val3,
          c(
            optim(c(amp,meanval,stddev,shift), residual_sum_squared_third)$par,
            optim(c(amp,meanval,stddev,shift), residual_sum_squared_third)$value
          )
        )
      }
    }
  }
}

est_parameters_third <- val3[val3[,5] == min(val3[,5]),1:4]
# est_parameters_third <- c(1.330033e+09, 7.505285e+00, 1.528345e+00, 3.000064e+01)

# With these parameters, we can PREDICT when the third wave would end. It is
# assumed here that the third wave is the final one, and for that reason the
# parameters would tell us when would the cases be lowered to 100 or 1000 cases,
# which might suggest the time Covid cases would supposedly be ending.

# Assuming that the wave would last for 400 days (about the length of first wave)
# we estimate the number of expected cases for the rest of the peiod.
x3_next <- 1:(400 - length(x3))

third_wave_rest <- est_parameters_third[1]*(dlnorm(
  x3_next+est_parameters_third[4],
  mean = est_parameters_third[2], sd=est_parameters_third[3]
))

# The plot of the values would be as below.
plot(third_wave_df$date, third_wave_df$cases, type = "l")
lines(
  third_wave_df$date,
  est_parameters_third[1]*(
    dlnorm(
      x3+est_parameters_third[4],
      mean = est_parameters_third[2], sd=est_parameters_third[3]
    )
  )
)