

crec <- function(course_id1, course_id2, course_id3) {
  course1_time <- course_data |>
                    filter(course_id == course_id1) |>
                    select(meeting_time)
  course2_time <- course_data |>
                  filter(course_id == course_id2) |>
                  select(meeting_time)
  course2_time <- course_data |>
                  filter(course_id == course_id3) |>
                  select(meeting_time)


  course_reccomendations <- course_data |>
      filter(meeting_time != course1_time) |>
      filter(meeting_time != course2_time) |>
      filter(meeting_time != course3_time) |>
      select(course_id, course_name, meeting_time, description)

  return(course_reccomendations)



}

library(dplyr)

course1_time <- course_data |>
  filter(course_id == "AFR11701") |>
  select(meeting_time)

course1_time

