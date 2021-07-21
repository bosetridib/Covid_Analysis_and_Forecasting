w <- read.csv('/home/jiraya/WHO-COVID-19-global-data.csv')
t <- sort(unique(w$Date_reported))
cn <- sort(unique(w$Country))

wt <- None
for (i in 1:length(t)) {
  wt[i] <- sum(w$New_cases[w$Date_reported == t[i]], na.rm = T)
}
t <- as.Date(t)
plot(t,wt, type = "l")
plot(t,log(wt), type = "p")
plot(t[-1], diff(wt), type = "l")

acf(diff(wt))
pacf(diff(wt))

x <- 1:length(t)
fn <- function(para) {
  return(sum((wt - (para[1]*dnorm(x, mean = para[2], sd = para[3])))^2))
}

val <- 0 ; k <- 1; m <-0
for (h in seq(2*10^7,8*10^7,by=5*10^6)) {
  for (i in seq(100,1000,by=25)) {
    for (j in seq(10,100,by=5)) {
      val[k] <- optim(  c(h,i,j),fn  )$value
      m[k] <- paste(as.character(h),",",as.character(i),",",as.character(j))
      k <- k+1
    }
  }
}

m[which(val == min(val))]

par <- c(5.7*10^07 , 220 , 70)
plot(t, wt, type="l")
lines(t,optim(par, fn)$par[1]*dnorm(x,optim(par, fn)$par[2],optim(par, fn)$par[3]))


# Experimentationalisticology

# u <- rnorm(100,0,10000)
# 
# x <- 1:100
# 
# y1 <- 10000000*dnorm(x,50,20)
# 
# plot(y1, type = "l", ylim = c(min(u),max(y1)))
# lines(x,u)
# lines(y1/u)