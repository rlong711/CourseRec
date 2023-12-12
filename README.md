
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
test_input <- c('AFR11701', 'AFR15501', 'AFR202am01')

classes <- course_recommend(test_input, course_data)
# classes[348,"meeting_time"]
```

## Adding criteria to course recommender

The user can choose to add more criteria than time to return more
specialized courses. For example, they can find all possible courses
based on time and a specific department:

``` r
classes_dept <- course_recommend_dept(test_input, 'MTH', course_data)
classes_dept
#>     course_id
#> 1    MTH11103
#> 2    MTH11104
#> 3    MTH11204
#> 4    MTH20501
#> 5    MTH21102
#> 6    MTH21202
#> 7    MTH25501
#> 8    MTH30001
#> 9  MTH301rs01
#> 10 MTH333la01
#> 11 MTH364pd01
#>                                                                                                    course_name
#> 1                                                                        \n            Calculus I\n           
#> 2                                                                        \n            Calculus I\n           
#> 3                                                                       \n            Calculus II\n           
#> 4                                                          \n            Modeling in the Sciences\n           
#> 5                                                                    \n            Linear Algebra\n           
#> 6                                                            \n            Multivariable Calculus\n           
#> 7                                                                      \n            Graph Theory\n           
#> 8                                           \n            Dialogues in Mathematics and Statistics\n           
#> 9                                           \n            Topics in Advanced Mathematics-Research\n           
#> 10                               \n            Topics in Abstract Algebra-Advanced Linear Algebra\n           
#> 11 \n            Advanced Topics in Continuous Applied Mathematics-Partial Differential Equations\n           
#>       course_instructor                                meeting_time
#> 1     Daniel Schultheis Monday/Wednesday/Friday | 1:20 PM - 2:35 PM
#> 2         Candice Price Monday/Wednesday/Friday | 8:00 AM - 9:15 AM
#> 3     Rebecca E Targove Monday/Wednesday/Friday | 8:00 AM - 9:15 AM
#> 4        Ileana Streinu Monday/Wednesday/Friday | 1:20 PM - 2:35 PM
#> 5             Pau Atela      Tuesday/Thursday | 10:50 AM - 12:05 PM
#> 6      Geremias Polanco Monday/Wednesday/Friday | 1:20 PM - 2:35 PM
#> 7     Theo Douvropoulos      Tuesday/Thursday | 10:50 AM - 12:05 PM
#> 8         Candice Price                Thursday | 1:20 PM - 2:35 PM
#> 9         Candice Price                 Tuesday | 7:00 PM - 9:30 PM
#> 10 Julianna S. Tymoczko        Monday/Wednesday | 7:00 PM - 8:20 PM
#> 11         Luca Capogna        Tuesday/Thursday | 2:45 PM - 4:00 PM
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                          Rates of change, differentiation, applications of derivatives including differential equations and the fundamental theorem of the calculus. Written communication and applications to other sciences and social sciences motivate course content.
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                          Rates of change, differentiation, applications of derivatives including differential equations and the fundamental theorem of the calculus. Written communication and applications to other sciences and social sciences motivate course content.
#> 3                                                                                                                                                                                                                                                                                                                                                                                     Techniques of integration, geometric applications of the integral, differential equations and modeling, infinite series and approximation of functions. Written communication and applications to other sciences and social sciences motivate course content. Prerequisite: MTH 111 or the equivalent.
#> 4                                                                                   Offered CSC 205 and MTH 205. This course integrates the use of mathematics and computers for modeling various phenomena drawn from the natural and social sciences. Scientific topics, organized as case studies, span a wide range of systems at all scales, with special emphasis on the life sciences. Mathematical tools include data analysis, discrete and continuous dynamical systems and discrete geometry. This is a project-based course and provides elementary training in programming using Mathematica. Prerequisites: MTH 112 or MTH 114. CSC 111 recommended. Enrollment limited to 20.
#> 5                                                                                                                                                                                                                                                                                                          Systems of linear equations, matrices, linear transformations, vector spaces. Applications to be selected from differential equations, foundations of physics, geometry and other topics. Students may not receive credit for both MTH 211 and MTH 210. Prerequisite: MTH 112 or the equivalent, or MTH 111 and MTH 153; MTH 153 is suggested. Enrollment limited to 35 students.
#> 6                                                                                                                                                                                                                                                                                                   Theory and applications of limits, derivatives and integrals of functions of one, two and three variables. Curves in two-and three-dimensional space, vector functions, double and triple integrals, polar, cylindrical, spherical coordinates. Path integration and Green’s Theorem. Prerequisites: MTH 112. It is suggested that MTH 211 be taken before or concurrently with MTH 212.
#> 7                                                                                                                                                                                                                 The course begins with the basic structure of graphs including connectivity, paths, cycles and planarity. e proceed to study independence, stability, matchings and colorings. Directed graphs and networks are considered. In particular, some optimization problems including maximum flow are covered. The material includes theory and mathematical proofs as well as algorithms and applications. Prerequisites: MTH 153 and MTH 211 or permission of the instructor.
#> 8                                                                                                                                                  In this class we don’t do math as much as we talk about doing math and the culture of mathematics. The class includes lectures by students, faculty and visitors on a wide variety of topics, and opportunities to talk with mathematicians about their lives. This course is especially helpful for those considering graduate school in the mathematical sciences. Prerequisites: MTH 211, MTH 212 and two additional mathematics courses at the 200-level, or permission of the instructor. May be repeated once for credit. S/U only.
#> 9                                                                                                                                                                                                  In this course students work in small groups on original research projects. Students are expected to attend a brief presentation of projects at the start of the semester. Recent topics include interactions between algebra and graph theory, plant patterns, knot theory, and mathematical modeling. This course is open to all students interested in gaining research experience in mathematics. Prerequisites vary depending on the project, but normally 153 and 211 are required.
#> 10                                                                                                                                                                                                                                                                                                                       This is a second course in linear algebra that explores the structure of matrices. Topics may include characteristic and minimal polynomials, diagonalization and canonical forms of matrices, the spectral theorem, the singular value decomposition theorem, an introduction to modules, and applications to problems in optimization, Markov chains, and others.
#> 11 Partial differential equations allow us to track how quantities change over multiple variables, e.g. space and time. This course provides an introduction to techniques for analyzing and solving partial differential equations and surveys applications from the sciences and engineering. Specific topics include Fourier series, separation of variables, heat, wave and Laplace’s equations, finite difference numerical methods, and introduction to pattern formations. Prerequisite: MTH 211, MTH 212, and MTH 264 strongly recommended) or MTH 280/281, or permission of the instructor. Prior exposure to computing (using Matlab, Mathematica, Python, etc.) will be helpful.
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
