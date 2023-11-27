# This contains the script for collecting the course catalog information from the
# Smith website

# hi this is Mattea
library(RSelenium)
library(tidyverse)
library(rvest)
library(dplyr)

url <- "https://www.smith.edu/academics/programs-courses/course-search"

webpage <- read_html(url)

# intializing a data frame
course_data <- data.frame(
  course_num = character(),
  course_sub = character(),
  course_code = character(),
  section_number = character(),
  course_name = character(),
  course_name = character(),
  instructor = character(),
  credits = character(),
  max_enroll = character(),
  section_enroll = character(),
  waitlist = character(),
  distribution = character(),
  meeting_time = character(),
  description = character(),
  stringsAsFactors = FALSE

)

course_elements <- html_nodes(webpage, "article.course.campus-course-search-result")

for (course_element in course_elements) {
  course_num <- html_text(html_node(course_element, ".course-dept"))
  course_sub <- html_text(html_node(course_element, ".course-course-subject"))
  course_code <- html_text(html_node(course_element, ".course-course-num"))
  section_number <- html_text(html_node(course_element, ".course-section-num"))
  course_name <- html_text(html_node(course_element, ".course-section-title a"))
  instructor <- html_text(html_node(course_element, ".course-section-instructor"))

  collapsed <- html_node(course_element, ".collapse.in.card.card-body.course-detail-body")
  credits <- html_text(html_node(collapsed, ".course-credits"))
  max_enroll <- html_text(html_node(collapsed, ".course-enrollment_max"))
  section_enroll <- html_text(html_node(collapsed, ".course-enrollment_tot"))
  waitlist <- html_text(html_node(collapsed, ".course-enrollment-waitlist"))
  distribution <- html_text(html_node(collapsed, ".course-todo:contains('Curriculum Distribution')"))
  meeting_time <- html_text(html_node(collapsed, ".course-meeting"))
  description <- html_text(html_node(collapsed, ".course-description p"))

  course_data <- course_data |>
    add_row(
      course_num = course_num,
      course_sub = course_sub,
      course_code = course_code,
      section_number = section_number,
      course_name = course_name,
      instructor = instructor,
      credits = credits,
      max_enroll = max_enroll,
      section_enroll = section_enroll,
      waitlist = waitlist,
      distribution = distribution,
      meeting_time = meeting_time,
      description = description
    )
}

print(course_data)

