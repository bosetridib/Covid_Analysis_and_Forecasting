# The data is taken in csv format from the WHO database
w <- read.csv('/home/jiraya/WHO-COVID-19-global-data.csv')
# The dates of cases in the whole world are taken
t <- sort(unique(w$Date_reported))
# Different countries are uniquely taken
cn <- sort(unique(w$Country))

# All the cases in the world are stored in each index
wt <- None
for (i in 1:length(t)) {
  wt[i] <- sum(w$New_cases[w$Date_reported == t[i]], na.rm = T)
}

# The dates are now formatted as Date datatype
t <- as.Date(t)

# Plot the data
plot(t,wt, type = "l")
plot(t,log(wt), type = "p")
plot(t[-1], diff(wt), type = "l")

# x is the index of time
x <- 1:length(t)

# The function here returns the residual sum squared of actual cases
# The argument passed in the function is the possible/potential parameters of the normal distribution
# 3 arguements h,i,j would be passed: h is the scale of the distribution, i is the mean and j is the SDev
fn <- function(para) {
  return(sum((wt - (para[1]*dnorm(x, mean = para[2], sd = para[3])))^2))
}

# Initiate variables for the computation of OLS parameters
val <- 0 ; k <- 1; m <-0

for (h in seq(2*10^7,8*10^7,by=5*10^6)) {
  for (i in seq(100,1000,by=25)) {
    for (j in seq(10,100,by=5)) {
      # The optimized function with respect to the h,i,j
      # value of the minimized RSS stored
      val[k] <- optim(  c(h,i,j),fn  )$value
      # Each m would have the different h,i,j
      m[k] <- paste(as.character(h),",",as.character(i),",",as.character(j))
      k <- k+1
    }
  }
}

# Which RSS is the lowest will determine the optimized parameters h,i,j
m[which(val == min(val))]

# The estimated normal distribution line
par <- c(5.7*10^07 , 220 , 70)
plot(t, wt, type="l")
lines(t,optim(par, fn)$par[1]*dnorm(x,optim(par, fn)$par[2],optim(par, fn)$par[3]))