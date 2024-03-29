% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ICCtoTIC.R
\name{plotICC_gg}
\alias{plotICC_gg}
\title{Plot Item Characteristic Curves (ICC) from Exametrika}
\usage{
plotICC_gg(data, xvariable = c(-4, 4))
}
\arguments{
\item{data}{Exametrika output results}

\item{xvariable}{Specify the vector to set the drawing range at both ends of the x-axis}
}
\description{
This function takes Exametrika output as input
and generates Item Characteristic Curves (ICC) using ggplot2.
The applicable analytical method is Item Response Theory (IRT).
}
