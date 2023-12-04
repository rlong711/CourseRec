# remove rows where meeting_time is NA to avoid error
course_data_na_removed <- course_data[!is.na(course_data$meeting_time), ]

#' @title Generate the meeting time of a course
#'
#' @description
#' Given a course ID and a data set of all courses, this function returns the meeting time of the inputted course as a character string,
#' if the course ID exists in courses data set.
#'
#' @param course A character vector identifying a course ID.
#' @param data A data set containing the entire course schedule. The default data set contains the course schedule of
#' all spring 2024 courses at Smith College.
#' @return A character vector of the meeting time of the course.
#'
#' @export
course_time <- function(course, data = course_data_na_removed) {

  for (row in 1:nrow(data)) {
    course_id <- data[row, "course_id"]

    if (setequal(course_id,course)) {
              course_time <- course_data[row, "meeting_time"]
            }
  }

  return(course_time)
}


#' @title Generate a course schedule for 3 courses
#'
#' @description
#' Given three character vectors of course IDs, this function returns their meeting times as a column in a data frame
#'
#' @param course1 the first course
#' @param course2 the second course
#' @param course3 the third course
#' @param data A data set containing entire course schedule. The default data set contains course schedule of
#' all spring 2024 courses at Smith College.
#' @return A data frame containing one column, which is a character vector of three meeting times
course_schedule <- function(course1, course2, course3, data = course_data_na_removed) {
  schedule_chr <- purrr::map_chr(test_input, course_time)

  schedule_df <- data.frame(
    times = schedule_chr
  )

  return(schedule_df)
}


#' @title Generate a fine grained schedule for course meeting times.
#'
#' @description
#' Given a character vector of course meeting times, this function returns a fine grained schedule.
#'
#' @param x A character vector of course meeting times.
#' @return A list of fine grained schedules indicating one start time and one end time for each weekday.
fine_grained_schedule <- function(x) {
  ## Split into pieces based on semicolon. This important for classes that have different meeting
  ## times on different days of the week.
  x <- strsplit(x, split = "; ", fixed = TRUE) |> unlist()

  extract_weekdays <- function(x) {
    regmatches(x, gregexpr("([A-Za-z]{3,6}day)", x))
  }
  weekdays <- extract_weekdays(x)

  extract_start_and_end <- function(x) {
    regmatches(x, gregexpr("[01]?[0-9]:[0-9]{2} (AM|PM)", x))
  }

  times <- extract_start_and_end(x)

  x <- purrr::map2(weekdays, times, \(w, t) {
    names(t) <- c("start", "end")
    a <- rep(list(t), length(w))
    names(a) <- w
    return(a)
  })

  unlist(x, recursive = FALSE)
}


#' @title Find if there's a time conflict between two fine grained schedules
#'
#' @description
#' Given two fine grained schedules, this function checks if they have any time conflicts
#'
#' @param a the first fine grained schedule
#' @param b the second fine grained schedule
#' @return A logical vector. TRUE if there is a time conflict, FALSE if not.
find_overlap <- function(a, b) {

  candidate_days <- a[names(b)]

  if (length(intersect(names(b), names(a))) == 0) {
    return(FALSE)
  }

  purrr::map2_lgl(b, candidate_days, \(x, y) {
    x_time <- lubridate::hm(sub("( AM)|( PM)", "", x))
    y_time <- lubridate::hm(sub("( AM)|( PM)", "", y))

    x_PM <- grepl("PM", x)
    x_time[x_PM] <- x_time[x_PM] + lubridate::hm("12:00")

    y_PM <- grepl("PM", y)
    y_time[y_PM] <- y_time[y_PM] + lubridate::hm("12:00")

    # overlap means: Does y's start time fall inside the start and end of x?
    # Or, does y's end time fall inside the start and end of x?

    overlap <- (x_time[1] <= y_time[1]) & (y_time[1] <= x_time[2]) |
      (x_time[1] <= y_time[2]) & (y_time[2] <= x_time[2])

    return(overlap)
  })
}


#' @title Generate all available courses
#'
#' @description
#' Given three courses the user plans to take,
#' this functions returns a character vector of all courses available to the user.
#'
#' @param course1 the first course the user plans to take
#' @param course2 the second course the user plans to take
#' @param course3 the third course the user plans to take
#' @param data Data set containing entire course schedule. The default data set contains course schedule of
#' all spring 2024 courses at Smith College.
#' @return A character vector of the course IDs of all available courses, meaning courses that do not have a
#' time conflict with what the user's three courses.
#' @importFrom purrr map
#'
#' @export
course_recommend <- function(course1, course2, course3, data = course_data_na_removed) {

  current_courses_schedule <- course_schedule(course1, course2, course3, data) |>
    purrr::map(fine_grained_schedule)

  all_courses_schedule <- data$meeting_time |>
    purrr::map(fine_grained_schedule)

  overlap <- all_courses_schedule |>
    purrr::map_lgl(\(x) {
      purrr::map(current_courses_schedule, find_overlap, x) |>
        unlist() |>
        any()
    })

  overlap[is.na(overlap)] <- FALSE

  data$overlap <- overlap

  available_courses <- vector("character")

  for (row in 1:nrow(data)) {
    course_id <- data[row, "course_id"]
    overlap <- data[row, "overlap"]

    if (overlap == FALSE) {
      available_courses <- append(available_courses, course_id)
    }
  }

  return(available_courses)
}





