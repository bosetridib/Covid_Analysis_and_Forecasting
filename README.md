# Covid Forecast by Curve-Fitting with R

The objective is to deconstruct and build the trend of the two waves by curve fitting. It is assumed that the waves are - log-normal and normal PDFs - shaped. The curve fitting is intended to give us the parameters of the trend.

#Flipped :

For the log normal distribution be X ~ L(m,s), the curve is right-skewed. But in our cases, we have to build the trend which is left-skewed, which is supposed to be a flipped version of the usual curve. For this, to build such a curve, we take Y=c-X, for c be the point on the horizontal axis where the required left-skewed curve would end. We have estimated the curve as Y=c-X for X ~ a*L(m,s), where a is the amplitude, m is mean, s is sd and c is the shift parameter - the four parameters that would be estimated with the 4-level iterations.

For the log normal distribution be X ~ L(m,s), the curve is right-skewed. But in our cases, we have to build the trend which is left-skewed, which is supposed to be a flipped version of the usual curve. For this, to build such a curve, we take Y=c-X, for c be the point on the horizontal axis where the required left-skewed curve would end. We have estimated the curve as Y=c-X for X ~ a*L(m,s), where a is the amplitude, m is mean, s is sd and c is the shift parameter - the four parameters that would be estimated with the 4-level iterations.
