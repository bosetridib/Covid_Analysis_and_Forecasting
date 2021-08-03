# Covid Forecast by Curve-Fitting with R

This project aims to build the trend of the daily covid cases by the method of _curve fitting_. It is assumed that the first and third wave can be described by log-normal distribution while the second wave can be described by normal distribution. The project would further aim to de-trend the data and build **time-series models** later on. The main concern of the project is to build the trend of the data to predict the cases in the near future. The older works in the project is also included separately.

## Installation

Nothing except R (https://www.r-project.org/) is currently required to run this project. Moreover, nothing except the built-in packages are required within R. The MS-Windows link to install R is https://cran.r-project.org/bin/windows/base/, and the MacOS link is https://cran.r-project.org/bin/macosx/. For linux one may see https://cran.r-project.org/bin/linux/, but installation from any package manager would be sufficient.

I used RStudio IDE (https://www.rstudio.com/products/rstudio/download/#download) which can be downloaded from their official website or from any available linux package managers.

### Hardware Warning

The first three iterations to estimate the parameters may take a long time, especially if one's using a processor like C2D (which is unfortunately I am using). For that, the default outcomes are provided in the comments below the multilevel for-loops. More iterations would definitely provide better, more efficient results - but 'necessarily' requires a better processor.

## Annotations

### Flipped-Lnorm:

For the log normal distribution be Z ~ L(x,m,s), the curve is right-skewed. But in our cases, we have to build the trend which is left-skewed, which is supposed to be a flipped version of the usual curve. For this, to build such a curve, we take y=c-x, for c be the point on the horizontal axis where the required left-skewed curve would end. We have estimated the curve as y=c-x for Z ~ a.L(x,m,s), where a is the amplitude, m is mean, s is sd and c is the shift parameter - the four parameters that would be estimated with the 4-level iterations. TL;DR - the shifted curve of Z ~ a.L(x,m,s) would be a.L(y,m,s) or a.L(c-x,m,s)

### Shifted-norm:

For the normal distribution be Z ~ N(x,m,s), the curve would be down towards the horizontal axis. But in the second wave, the required curve is supposedly shifted parallel upwards. For this, the fourth parameter is to be estimated that how much value the fitted curve is shifted upwards, ie. for the required curve be Y=c+Z, we estimate c+N(x,m,s).

### The likely outcomes:

The sample outcomes are presented here, dating to upto July, 2021. The first one demonstrates the trend building while the second on shows the projections and expected date of when the pandemic is likely over.

![alt text](https://github.com/bosetridib/Covid_Analysis_and_Forecasting/blob/main/CovidTrendJuly21.jpeg "The trend")

The above graph is one of the most likely outcomes. The dashed line is the trend.

![alt text](https://github.com/bosetridib/Covid_Analysis_and_Forecasting/blob/main/CovidForecastJuly21.jpeg "The forecast")

The above plot would change with time, as more data is incorporated. The third wave estimation would change each day, until the _war with pandemic_ is over.

## Projects

There are two currently. The old one is dated to June, 2020 and based on the data until then. The main project however, is based on new data and incorporates several additions and many modification in the estimation and coding. The basic idea, however, remains the same.

```R
# The idea

u <- rnorm(100,0,10000)

x <- 1:100

y <- 10000000*dnorm(x,50,20)

default_par <- par()
par(mfrow=c(1,2))

plot(y, type = "l", ylim = c(min(u),max(y)))
lines(y+u)
lines(u)

plot(y+u, type = "l")
par(default_par)
rm(default_par)
```
The visual inspection of the above trend and variation in the above plot has what inspired the project in the beginning, but further effort was a result of learning more about data science, econometrics and through independent researches.

### Main Project

The main project is on the file covmain.R, on which the subsequent estimations in time-series models will be based. In the main project, the flipped and shifted versions of the PDFs is used, which was not incorporated in the old one. In the estimation, apart from the shifting parameters and the flipped form of the PDFs, the method for projection of the cases is also different. For projection, parameters of the first wave are used in estimation, as they seem to be having similar qualities.

### Old Project

The files covOld.R and covOldL.R represents the old project, which was done in June, 2020 during the beginning of the first wave. The plot suggests that the data indeed have a trend with normal or log-normal PDF (probability density function). Both of the estimation methods in the two files are taken and modified in the main project. The graph below would show what were the previous results.

## Future

The estimated parameters and the dataframes in the main files would be taken to build time-series models. It can be suspected that the models are of the form ARIMA and suffers from volatility.