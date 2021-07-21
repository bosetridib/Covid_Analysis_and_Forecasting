w <- read.csv('/home/jiraya/WHO-COVID-19-global-data.csv')
t <- sort(unique(w$Date_reported))
cn <- sort(unique(w$Country))

wt <- 0
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
fn1 <- function(para) {
  return(sum((wt - (para[1]*dlnorm(x, para[2], para[3])))^2))
}

val <- 0 ; k <- 1; m <- NULL
for (h in seq(10^5,10^6,by=0.25*10^5)) {
  for (i in seq(1,6,by=0.05)) {
    for (j in seq(0.1,6,by=0.1)) {
      val[k] <- optim(  c(h,i,j),fn1  )$value
      m[k] <- paste(as.character(h),",",as.character(i),",",as.character(j))
      k <- k+1
    }
  }
}

m[which(val == min(val))]

parr <- c(125000 , 4.8 , 4.1)
estd <- optim(parr, fn1)$par[1]*dlnorm(x,optim(parr, fn1)$par[2],optim(parr, fn1)$par[3])
plot(t, wt, type="l")
lines(t,estd)

y <- 200
t[which(optim(parr, fn1)$par[1]*dlnorm(x+y,optim(parr, fn1)$par[2],optim(parr, fn1)$par[3]) < 100)]+y
plot( c(t,t[length(t)]+(1:y)), c( wt , rep(wt[which.max(wt)],y) ), type="l" )
lines(c(t,t[length(t)]+(1:y)), optim(parr, fn1)$par[1]*dlnorm(c(x,x[length(x)]+(1:y)),optim(parr, fn1)$par[2],optim(parr, fn1)$par[3]))

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