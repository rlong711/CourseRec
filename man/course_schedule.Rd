% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Course_rec.R
\name{course_schedule}
\alias{course_schedule}
\title{Generate a course schedule for 3 courses}
\usage{
course_schedule(courses, data)
}
\arguments{
\item{courses}{a character vector of length 3 containing the course IDs of all 3 courses the user plans to take.}

\item{data}{A data set containing entire course schedule.}
}
\value{
A data frame containing one column, which is a character vector of three meeting times
}
\description{
Given three character vectors of course IDs, this function returns their meeting times as a column in a data frame
}
