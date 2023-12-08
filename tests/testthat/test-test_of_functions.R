test_that("scrap_course_data returns desired data frame", {
  expect_type(scrap_course_data(2023, "Fall"), "data.frame")
})

test_that("")
