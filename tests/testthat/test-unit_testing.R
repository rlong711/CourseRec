test_that("scrap_course_data function returns a data frame with the correct input.", {
  expect_type(scrap_course_data(2023, "Fall"), "list")
})

test_that("course_recommend pints out desired output", {
  expect_type(course_recommend(c("AFR11701", "ARH21701", "BIO12302"), "character"))
})

test_that("course_description test", {
  expect_equal(course_description("AFR11701", course_data), course_data |>
                 dplyr::filter(course_id == "AFR11701") |>
                 dplyr::select(description) )
})


