% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Course_rec.R
\name{create_url}
\alias{create_url}
\title{Create url to Smith course search website of a single semester}
\usage{
create_url(year, semester)
}
\arguments{
\item{year}{A scalar numeric vector indicating the year}

\item{semester}{A character vector indicating whether the semester is the fall, spring or interterm semester}
}
\value{
A character vector containing a url to the course search website of the indicated semester
}
\description{
Given the year and semester, this funciton creates a url to course search website of Smith College of that
semester
}
