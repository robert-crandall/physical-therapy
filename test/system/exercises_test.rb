require "application_system_test_case"

class ExercisesTest < ApplicationSystemTestCase
  setup do
    @exercise = exercises(:one)
  end

  test "visiting the index" do
    visit exercises_url
    assert_selector "h1", text: "Exercises"
  end

  test "should create exercise" do
    visit exercises_url
    click_on "New exercise"

    fill_in "Category", with: @exercise.category_id
    fill_in "Image", with: @exercise.image
    fill_in "Lift scheme", with: @exercise.lift_scheme
    fill_in "Link", with: @exercise.link
    fill_in "Name", with: @exercise.name
    click_on "Create Exercise"

    assert_text "Exercise was successfully created"
    click_on "Back"
  end

  test "should update Exercise" do
    visit exercise_url(@exercise)
    click_on "Edit this exercise", match: :first

    fill_in "Category", with: @exercise.category_id
    fill_in "Image", with: @exercise.image
    fill_in "Lift scheme", with: @exercise.lift_scheme
    fill_in "Link", with: @exercise.link
    fill_in "Name", with: @exercise.name
    click_on "Update Exercise"

    assert_text "Exercise was successfully updated"
    click_on "Back"
  end

  test "should destroy Exercise" do
    visit exercise_url(@exercise)
    click_on "Destroy this exercise", match: :first

    assert_text "Exercise was successfully destroyed"
  end
end
