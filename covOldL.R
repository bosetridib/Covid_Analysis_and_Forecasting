who_global <- read.csv('WHO-COVID-19-global-data.csv')
t <- sort(unique(who_global$Date_reported))

# All the cases in the world are stored in each index
who_daily_t <- NULL
for (i in 1:length(t)) {
  who_daily_t[i] <- sum(who_global$New_cases[who_global$Date_reported == t[i]], na.rm = T)
}
rm(who_global)

t <- as.Date(t)

x <- 1:length(t)

fnL <- function(para) {
  return(sum((who_daily_t - (para[1]*dlnorm(x, para[2], para[3])))^2))
}

val <- NULL ; k <- 1; m <- NULL

for (h in seq(10^5,10^6,by=0.25*10^5)) {
  for (i in seq(1,6,by=0.05)) {
    for (j in seq(0.1,6,by=0.1)) {
      val[k] <- optim(  c(h,i,j),fnL  )$value
      m <- rbind(m, c(h,i,j))
      k <- k+1
    }
  }
}

# parr <- m[which(val == min(val)),]
parr <- c(125000 , 4.8 , 4.1)
estd <- optim(parr, fnL)$par[1]*dlnorm(x,optim(parr, fnL)$par[2],optim(parr, fnL)$par[3])
plot(t, who_daily_t, type="l")
lines(t,estd)

y <- 200
t[which(optim(parr, fnL)$par[1]*dlnorm(x+y,optim(parr, fnL)$par[2],optim(parr, fnL)$par[3]) < 100)]+y
plot( c(t,t[length(t)]+(1:y)), c( who_daily_t , rep(who_daily_t[which.max(who_daily_t)],y) ), type="l" )
lines(c(t,t[length(t)]+(1:y)), optim(parr, fnL)$par[1]*dlnorm(c(x,x[length(x)]+(1:y)),optim(parr, fnL)$par[2],optim(parr, fnL)$par[3]))