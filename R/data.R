#' Metadata for all Smith College Spring 2024 courses (thus far)
#'
#' @format A data frame with 763 rows and 15 columns
#' \describe{
#'  \item{course_num}{Course number}
#'  \item{course_dept}{Department the course is in}
#'  \item{course_sub}{Course subject}
#'  \item{course_section}{Section of the course}
#'  \item{course_name}{Name of the course}
#'  \item{course_instructor}{Instructor of the course}
#'  \item{course_status}{Status of the course (i.e. if it is open for registration)}
#'  \item{credits}{Credits of the course}
#'  \item{section_enroll}{Current enrollment of the class section}
#'  \item{max_enroll}{Maximun number of enrollment}
#'  \item{waitlist}{Current number of people on the waitlist}
#'  \item{reserved}{If there are reserved seats in this course}
#'  \item{meeting_time}{Time of course sessions}
#'  \item{description}{Course description}
#'  \item{course_id}{A unique identifier that is created by pasting together course_sub, course_num and course_section}
#' }
#' @source <https://www.smith.edu/apps/course_search/>

"course_data"
