# This contains the script for collecting the course catalog information from the
# Smith website

# hi this is Mattea
library(tidyverse)
library(rvest)

url <- "https://www.smith.edu/academics/programs-courses/course-search"

course_info <- read_html(url)
course_info

course_info <- course_info |>
  html_attr("")
course_info

