# The data is taken in csv format from the WHO database
who_global <- read.csv('WHO-COVID-19-global-data.csv')

# The dates of cases worldwide are taken
t <- sort(unique(who_global$Date_reported))

# All the cases in the world are stored in each index
who_daily_t <- NULL
for (i in 1:length(t)) {
  who_daily_t[i] <- sum(who_global$New_cases[who_global$Date_reported == t[i]], na.rm = T)
}
rm(who_global)

# The dates are now formatted as Date datatype
t <- as.Date(t)

# Plot the data
plot(t,who_daily_t, type = "l")
plot(t,log(who_daily_t), type = "l")
plot(t[-1], diff(who_daily_t), type = "l")

# x is the index of time
x <- 1:length(t)

# The function here returns the residual sum squared of actual cases
# The argument passed in the function is the possible/potential parameters of the normal distribution
# 3 arguements h,i,j would be passed: h is the scale of the distribution, i is the mean and j is the SDev
fn <- function(para) {
  return(sum((who_daily_t - (para[1]*dnorm(x, mean = para[2], sd = para[3])))^2))
}

# Initiate variables for the computation of OLS parameters
val <- NULL ; k <- 1; m <- NULL

for (h in seq(2*10^7,8*10^7,by=5*10^6)) {
  for (i in seq(100,1000,by=25)) {
    for (j in seq(10,100,by=5)) {
      # The optimized function with respect to the h,i,j
      # value of the minimized RSS stored
      val[k] <- optim(  c(h,i,j),fn  )$value
      # Each m would have the different h,i,j
      m <- rbind(m, c(h,i,j))
      k <- k+1
    }
  }
}


# Which RSS is the lowest will determine the optimized parameters h,i,j
m[which(val == min(val)),]

# The estimated normal distribution line
par <- c(5.7*10^07 , 220 , 70)
plot(t, who_daily_t, type="l")
lines(t,optim(par, fn)$par[1]*dnorm(x,optim(par, fn)$par[2],optim(par, fn)$par[3]))
