# This contains the script for collecting the course catalog information from the
# Smith website


# This is Hebe
library(tidyverse)
library(rvest)

courses <- read_html("https://www.smith.edu/apps/course_search/")

course_dept <- courses %>%
  html_elements(css = "span.course-dept") %>%
  html_text()
