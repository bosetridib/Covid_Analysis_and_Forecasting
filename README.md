# Covid Forecast by Curve-Fitting with R

The objective is to forecast the Covid cases, assuming that the cases follows normal or log-normal distribution function. For this, simple normal and log-normal curve fitting of daily CoViD cases is attempted.

The data is taken from WHO-database, and is cleaned-structured for daily cases all over the world. Then the fitting is done with the inbuilt dnorm function by minimizing the least square residuals.
