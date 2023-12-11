test_that("scrap_course_data function returns a data frame with the correct input.", {
  expect_equal(scrap_course_data(2023, "Fall"), course_data)
})

test_that("course_recommend pints out desired output", {
  expect_type(course_recommend(c("AFR11701", "ARH21701", "BIO12302"), "character"))
})

test_that("course_description test", {
  expect_error(course_description("AHS", course_data), "Course ID input is not valid. Pease input a valid course ID.")
})

test_that("course_meeting_time test", {
  expect_error(course_meeting_time("AHS2390", course_data), "Course ID input is not valid. Please input a valid course Id")
})

test_that("subject_rec test", {
  expect_error(subject_rec("AHS", course_data), "Not a valid course subject. Please enter a valid course subject.")
})

test_that("course_recommend_exclude_day test", {
  expect_warning(course_recommend_exclude_day(c("AHS130", "AFR11701", "ANT23401"), "Friday", "HST", course_data), "Please reenter courses in correct format")
  expect_warning(course_recommend_exclude_day(c("ARS20001", "AFR11701", "ANT23401"), "Tursday", "HST", course_data), "Invalid day of the week. Please enter a valid day.")
  expect_warning(course_recommend_exclude_day(c("ARS20001", "AFR11701", "ANT23401"), "Thursday", "HET", course_data))
})

test_that("course_recommend_dept test", {
  expect_warning(course_recommend_dept(c("ATS20001", "AFR11701", "ANT23401"), "HST", course_data), "One or more courses does not exist. Please reenter courses in correct format")
  expect_warning(course_recommend_dept(c("ARS20001", "AFR11701", "ANT23401"), "HET", course_data), "This department does not exist. Please reenter a valid department")
})






