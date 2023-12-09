
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CourseRec

<!-- badges: start -->
<!-- badges: end -->

The main goal of CourseRec is to help the user find a fourth class to
take in a given semester at Smith College, according to user inputted
criteria.

## Installation

You can install the development version of CourseRec from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rlong711/CourseRec")
```

## Scraping a courses data set

The user would first scrap their own data set from the Smith College
course search website (‘<https://www.smith.edu/apps/course_search/>’)
for specified semesters to be used with all the package functions:

``` r
library(CourseRec)

course_data <- scrap_course_data(2022, 'SPRING')
```

## Basic course recommender

Given 3 classes the user already plans to take, the course_recommend
function returns all courses that do not have a time conflict:

``` r
# classes <- course_recommend(c('AFR11701', 'AFR17501', 'AFR24901'), course_data)
# classes
```

## Adding criteria to course recommender

The user can choose to add more criteria than time to return more
specialized courses. For example, they can find all possible courses
based on time and a specific department:

``` r
classes_dept <- course_recommend_dept(c('AFR11701', 'AFR17501', 'AFR24901'), 'MTH', course_data)
#> Warning in course_recommend_dept(c("AFR11701", "AFR17501", "AFR24901"), : One
#> or more courses does not exist. Please reenter courses in correct format
classes_dept
#> NULL
```

## Learning about information to specific courses

The user can also retrieve specific information about a certain course
they are interested in, such as the meeting time of that course:

``` r
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
course_meeting_time('SDS27001', course_data)
#>                             meeting_time
#> 1 Tuesday/Thursday | 10:50 AM - 12:05 PM
```
