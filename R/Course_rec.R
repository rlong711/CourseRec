


course_recommend_department <- function(course1, course2, course3, department, data = course_data_na_removed) {
  matching_rows <- grep(paste0("^", department), data$course_id, value = TRUE)

  filtered_data <- data[matching_rows, ]

  available_courses <- course_recommend(course1, course2, course3, data= filtered_data)

  return(available_courses)
}

course_recommend_department('AFR11701', 'AFR17501', 'AFR24901', 'MTH')

