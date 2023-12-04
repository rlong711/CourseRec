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

#################

# x is the set of classes you're currently taking
x <- data.frame(
  times = c(
    "Tuesday/Thursday | 8:25 AM - 9:15 AM",
    "Wednesday/Friday | 1:20 PM - 2:35 PM; Monday | 1:40 PM - 2:55 PM",
    "Tuesday | 1:20 PM - 4:00 PM"
  )
)

# y contains all classes in the dataframe, which you want to see if it will fit in your schedule
# remove rows where meeting_time is NA to avoid error

course_data_na_removed <- course_data[!is.na(course_data$meeting_time), ]

y <- course_data_na_removed$meeting_time

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

find_overlap <- function(a, b) {
  # a and b are class schedules that have been turned into 'fine grained schedules'
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

overlap <- purrr::map(x$times, fine_grained_schedule) |>
  purrr::map(find_overlap, fine_grained_schedule(y))

overlap


course_recommend_department <- function(course1, course2, course3, department, data = course_data_na_removed) {
  matching_rows <- grep(paste0("^", department), course_data$course_id, value = TRUE)

  filtered_data <- course_data[matching_rows, ]

  available_courses <- course_recommend(course1, course2, course3, data= filtered_data)

  return(available_courses)
}

course_recommend_department('AFR11701', 'AFR17501', 'AFR24901', 'MTH')

