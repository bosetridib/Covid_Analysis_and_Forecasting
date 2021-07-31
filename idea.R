# The idea

u <- rnorm(100,0,10000)

x <- 1:100

y1 <- 10000000*dnorm(x,50,20)

plot(y1, type = "l", ylim = c(min(u),max(y1)))
lines(x,u)
lines(y1+u)