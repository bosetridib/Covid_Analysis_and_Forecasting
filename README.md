# Covid Forecast by Curve-Fitting with R

The objective is to deconstruct and build the trend of the two waves by curve fitting. It is assumed that the waves are log-normal and normal PDFs - shaped.

#Flipped :

For the log normal distribution be X ~ L(m,s), the curve is right-skewed. But in our cases, we have to build the trend which is left-skewed. For this, to build such a curve, we take Y=c-X, for c be the point on the horizontal axis where the left-skewed curve would end.