library(usethis)
library(devtools)

# remove rows where meeting_time is NA to avoid error
course_data_na_removed <- course_data[!is.na(course_data$meeting_time), ]

test_input <- c("AFR11701", "AFR17501", "AFR202aa01")

## function to return meeting time of inputted course as a chr string
course_time <- function(course, data = course_data_na_removed) {

  for (row in 1:nrow(data)) {
    course_id <- data[row, "course_id"]

    if (setequal(course_id,course)) {
      course_time <- course_data[row, "meeting_time"]
    }
  }

  return(course_time)
}

# test_schedule <- purrr::map_chr(test_input, course_time)


## function to generate dataframe containing meeting times for 3 courses
course_schedule <- function(course1, course2, course3, data = course_data_na_removed) {
  schedule_chr <- purrr::map_chr(test_input, course_time)

  schedule_df <- data.frame(
    times = schedule_chr
  )

  return(schedule_df)
}

# course_schedule(test_input)

## function to generate fine grained schedule, input type: dataframe
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


## function to see if two fine grained schedules contain any time conflicts
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


## course recommender, what the user calls to recommend courses
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

available_courses <- course_recommend(test_input)
available_courses



# okay back to the old approach

course_rec_dept <- function(course1, course2, course3, dept, data = course_data_na_removed) {
  courses <- c(course1, course2, course3)

  if(!all(courses %in% data$course_id)) {
    warning("Please reenter courses in correct format")
    return(NULL)
  }

  current_courses_schedule <- course_schedule(course1, courses2, courses3, data) |>
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

  available_classes <- data[data$course_dept == dept & !data$course_id %in% courses & !data$overlap, ]
  available_courses <- available_classes$course_id
  return(as.data.frame(available_courses))
}

recs <- course_rec_dept('AFR11701', 'AFR17501', 'AFR24901', 'MTH')
recs

# function to allow user to specify day of the week they want to meet (e.g. if someone
# does not want to have classes on friday)






