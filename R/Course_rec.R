library(usethis)
library(devtools)

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


#'
#' A function which allows the user to specify a department they would like to take
#' a class in, e.g. MTH for the Math department
#'
#' @param course1 the first course the user is taking
#' @param course2 the second course the user is taking
#' @param course3 the third course the user is taking
#' @param dept the three letter department code which the user wants to search
#' @return a dataframe of all possible classes within the specified department which have no overlap with the entered classes
#' @examples
#' course_rec_dept('AFR11701', 'AFR17501', 'AFR24901', 'MTH')
#'
#'

course_rec_dept <- function(course1, course2, course3, dept, data = course_data_na_removed) {

  # making argument inputs into a vector for checking validity of arguments
  courses <- c(course1, course2, course3)

  # checking if course exists before proceeding
  if(!all(courses %in% data$course_id)) {
    warning("One or more courses does not exist. Please reenter courses in correct format")
    return(NULL)
  }

  # checking if entered department exists before proceeding
  if (!(dept %in% data$course_dept)) {
    warning("This department does not exist. Please reenter a valid department")
    return(NULL)
  }

  # creating different schedules to check overlap
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

  # getting the available classes based on the department
  available_classes <- data[data$course_dept == dept & !data$course_id %in% courses & !data$overlap, ]

  #returning results as a dataframe which includes more information for the user
  result_df <- data.frame(
    course_id = available_classes$course_id,
    course_name = available_classes$course_name,
    course_instructor = available_classes$course_instructor,
    meeting_time = available_classes$meeting_time,
    description = available_classes$description
  )

  return(result_df)
}

# just testing
#recs <- course_rec_dept('AFR11701', 'AFR17501', 'AFR24901', 'MTH')
#notrecs <- course_rec_dept('AFR11701', 'AFR17501', 'AFR24901', 'BTS')


# Function which allows the user to optionally enter a day that will be excluded from the search (any classes that meet that day
# will not be returned) as well as optionally specify a department

#'
#'Function which allows the user to optionally enter a day that will be excluded from the search (any classes that meet that day
# will not be returned) as well as optionally specify a department.
#'
#'@param course1 the first course the user is already taking
#'@param course2 the second course the user is already taking
#'@param course3 the third course the user is already taking
#'@param exclude_day the day of the week the user wants to exclude from the search. any classes which meet on this day will NOT be returned
#'@param dept he three letter department code which the user wants to search
#'@return a dataframe containing all the classes the user can take with the corresponding optional criteria
#'@examples
#'course_rec_exclude_day_dept('AFR11701', 'AFR17501', 'AFR24901', 'Monday', 'MTH')
#'
course_rec_exclude_day_dept <- function(course1, course2, course3, exclude_day, dept, data = course_data_na_removed) {
  # for validation of course existence
  courses <- c(course1, course2, course3)

  #verifying courses exist
  if(!all(courses %in% data$course_id)) {
    warning("Please reenter courses in correct format")
    return(NULL)
  }

  #verifying entered day argument is valid
  valid_days <- c("Monday", "Tuesday", "Tuesday", "Thursday", "Friday", "Saturday", "Sunday")
  if(!is.null(exclude_day) && !(tolower(exclude_day) %in% valid_days)) {
    warning("Invalid day of the week. Please enter a valid day.")
  }

  #verifying department is valid
  if (!is.null(dept) && !(dept %in% unique(data$course_dept))) {
    warning("Invalid department. Please enter a valid departmend.")
    return(NULL)
  }

  #schedules for overlap checking
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

  available_classes <- data[!data$course_id %in% courses & !data$overlap, ]

  # finding classes within department if department field is entered and valid
  if (!is.null(dept)) {
    available_classes <- available_classes[available_classes$course_dept == dept, ]
  }

  # finding classes excluding day if day field is entered and valid
  if (!is.null(exclude_day)) {
    exclude_day <- tolower(substr(exclude_day, 1, 3))
    available_classes <- available_classes[!grepl(exclude_day, available_classes$meeting_time, ignore.case = TRUE), ]
  }

  #returning resulting data frame with proper criteria filters and additional information for user
  result_df <- data.frame(
    course_id = available_classes$course_id,
    course_name = available_classes$course_name,
    course_instructor = available_classes$ course_instructor,
    meeting_time = available_classes$meeting_time,
    description = available_classes$description
  )

  return(result_df)
}

# # Testing!
# rec_dept_day1 <- course_rec_exclude_day_dept('AFR11701', 'AFR17501', 'AFR24901', 'Monday', NULL)
# rec_dept_day2 <- course_rec_exclude_day_dept('AFR11701', 'AFR17501', 'AFR24901', 'Monday', 'MTH')
# rec_dept_3 <- course_rec_exclude_day_dept('AFR11701', 'AFR17501', 'AFR24901', NULL, 'MTH')
#
#not_rec_dept_day <- course_rec_exclude_day_dept('AFR11701', 'AFR17501', 'AFR24901', 'MyDay', 'BTS')





