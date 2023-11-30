library(usethis)
library(devtools)

# Basic function:

course_time <- function(course) {

  for (row in 1:nrow(course_data)) {
    course_id <- course_data[row, "course_id"]

    if (setequal(course_id,course)) {
              course_time <- course_data[row, "meeting_time"]
            }
  }

  return(course_time)
}

course_time("AFR11701")


course_recommend <- function(course1, course2, course3) {

  time1 <- course_time(course1)
  time2 <- course_time(course2)
  time3 <- course_time(course3)

  available_courses <- vector("character")

  for (row in 1:nrow(course_data)) {
    course_id <- course_data[row, "course_id"]
    new_time <- course_data[row, "meeting_time"]

    if (!setequal(new_time,time1) && !setequal(new_time,time2) && !setequal(new_time,time3)) {
      available_courses <- append(available_courses, course_id)
    }
  }

  return (available_courses)
}

course_recommend("AFR11701","AFR17501","AFR202aa01")


















