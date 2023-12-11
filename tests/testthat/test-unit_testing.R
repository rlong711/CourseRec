test_that("scrap_course_data function returns a data frame with the correct input.", {
  expect_equal(scrap_course_data(2023, "Fall"), course_data)
})

test_that("course_recommend pints out desired output", {
  expect_type(course_recommend(c("AFR11701", "ARH21701", "BIO12302"), "character"))
})

test_that("course_description test", {
  expect_error(course_description("AHS", course_data), "Course ID input is not valid. Pease input a valid course ID.")
})






