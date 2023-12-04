# preserve this code temporarily so we have sth to fall back on in case the course_rec code does not work


current_classes <- data.frame(
  times = c(
    "Monday/Wednesday | 9:25 AM - 10:40 AM",
    "Wednesday/Friday | 1:20 PM - 2:35 PM; Monday | 1:40 PM - 2:55 PM ",
    "Tuesday | 9:25 AM - 12:00 AM "
  )
) |>
  purrr::map(fine_grained_schedule)


all_courses_schedule <- course_data_na_removed$meeting_time |>
  purrr::map(fine_grained_schedule)

overlap <- all_courses_schedule |>
  purrr::map_lgl(\(x) {
    purrr::map(current_classes, find_overlap, x) |>
      unlist() |>
      any()
  })

overlap[is.na(overlap)] <- FALSE


course_data_na_removed$overlap <- overlap

available_courses <- course_recommend(course_data_na_removed)
