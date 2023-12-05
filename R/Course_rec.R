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





