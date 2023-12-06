create_url <- function(year, semester) {

  semester <- toupper(semester)

  if (semester == "FALL") {
    year <- as.character(year + 1)
    semester <- "01"
  } else if (semester == "SPRING") {
    year <- as.character(year)
    semester <- "03"
  } else if (semester == "INTERTERM") {
    year <- as.character(year)
    semester <- "02"
  }

  url <- paste("https://www.smith.edu/apps/course_search/?term=",year,semester,"&dept=&instructor=&instr_method=&credits=&course_number=&course_keyword=&csrf_token=IjA4YjU1NzY1MWVjZGM1Y2I4Zjc5YTI2NGI3ZTRjMzVhMTRhNjI0Y2Yi.ZW_GmQ.FNEfr0kGEekCEmogkG6zuQzLHb8&op=Submit&form_id=campus_course_search_basic_search_form",
               sep ="")
}

remove_locations <- function(x) {
  z <- mgsub(pattern = c("Sabin-Reed ", "Ainsworth 304; ", "Ainsworth Gym; ", "[0-9]; "),
             replacement = c("SR ", "AG ", "AG ", " "), string = x)
  sub(" \\/ [[:alnum:] ]+$", "", z)
}

scrap_course_data <- function(year, semester) {

  url <- create_url(year, semester)

  courses <- read_html(url)

  # intializing a data frame
  course_data <- data.frame(
    course_num = character(),
    course_dept = character(),
    course_sub = character(),
    course_section = character(),
    course_name = character(),
    course_instructor = character(),
    course_status = character(),
    credits = character(),
    max_enroll = character(),
    section_enroll = character(),
    waitlist = character(),
    reserved = character(),
    meeting_time = character(),
    description = character(),
    stringsAsFactors = FALSE

  )

  course_elements <- courses |>
    html_elements("article.course.campus-course-search-result")

  for (course_element in course_elements) {
    course_num <- html_text(html_node(course_element, ".course-course-num"))
    course_dept <- html_text(html_node(course_element, ".course-dept"))
    course_sub <- html_text(html_node(course_element, ".course-course-subject"))
    course_section <- html_text(html_node(course_element, ".course-section-num"))
    course_name <- html_text(html_node(course_element, ".course-section-title a"))
    course_instructor <- html_text(html_node(course_element, ".course-section-instructor"))
    course_status <- html_text(html_node(course_element, ".course-section-status"))

    credits <- html_text(html_node(course_element, "span.course-result-detail.course-credits")) |> substring(10, )
    max_enroll <- html_text(html_node(course_element, "span.course-result-detail.course-enrollment_max")) |> substring(17,)
    section_enroll <- html_text(html_node(course_element, "span.course-result-detail.course-enrollment_tot")) |> substring(21, )
    waitlist <- html_text(html_node(course_element, "span.course-result-detail.course-enrollment-waitlist")) |> substring(18, )
    reserved <- html_text(html_node(course_element, "span.course-result-detail.course-reserved-ind")) |> substring(17, )
    meeting_time <- html_text(html_node(course_element, "span.course-result-detail.course-meeting")) |> substring(16, )
    description <- html_text(html_node(course_element, "span.course-result-detail.course-description p"))

    course_data <- course_data |>
      add_row(
        course_num = course_num,
        course_sub = course_sub,
        course_dept = course_dept,
        course_section = course_section,
        course_name = course_name,
        course_instructor = course_instructor,
        course_status = course_status,
        credits = credits,
        max_enroll = max_enroll,
        section_enroll = section_enroll,
        waitlist = waitlist,
        reserved = reserved,
        meeting_time = meeting_time,
        description = description
      )
  }

  course_data$course_id = paste(course_data$course_sub, course_data$course_num, course_data$course_section, sep = "")

  course_data$meeting_time <- remove_locations(course_data$meeting_time)

  return(course_data)
}




#' @title Generate the meeting time of a course
#'
#' @description
#' Given a course ID and a data set of all courses, this function returns the meeting time of the inputted course as a character string,
#' if the course ID exists in courses data set.
#'
#' @param course A character vector identifying a course ID.
#' @param data A data set containing the entire course schedule.
#' @return A character vector of the meeting time of the course.
#'
#' @export
course_time <- function(course, data) {

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
#' @param courses a character vector of length 3 containing the course IDs of all 3 courses the user plans to take.
#' @param data A data set containing entire course schedule.
#' @return A data frame containing one column, which is a character vector of three meeting times
course_schedule <- function(courses, data) {

  if (length(courses)!=3) {
    stop("You must have and only have three courses.")
  }

  schedule_chr <- purrr::map_chr(courses, course_time, data)

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
#' @param courses a character vector of length 3 containing the course IDs of all 3 courses the user plans to take.
#' @param data Data set containing entire course schedule.
#' @return A character vector of the course IDs of all available courses, meaning courses that do not have a
#' time conflict with what the user's three courses.
#' @importFrom purrr map
#'
#' @export
course_recommend <- function(courses, data = course_data) {

  # remove rows where meeting_time is NA to avoid error
  data <- data[!is.na(data$meeting_time), ]

  current_courses_schedule <- course_schedule(courses, data) |>
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





