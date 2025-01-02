require "application_system_test_case"

class ExerciseHistoriesTest < ApplicationSystemTestCase
  setup do
    @exercise_history = exercise_histories(:one)
  end

  test "visiting the index" do
    visit exercise_histories_url
    assert_selector "h1", text: "Exercise histories"
  end

  test "should create exercise history" do
    visit exercise_histories_url
    click_on "New exercise history"

    fill_in "Exercise", with: @exercise_history.exercise_id
    fill_in "Reps", with: @exercise_history.reps
    fill_in "Sets", with: @exercise_history.sets
    check "Success" if @exercise_history.success
    fill_in "Weight", with: @exercise_history.weight
    click_on "Create Exercise history"

    assert_text "Exercise history was successfully created"
    click_on "Back"
  end

  test "should update Exercise history" do
    visit exercise_history_url(@exercise_history)
    click_on "Edit this exercise history", match: :first

    fill_in "Exercise", with: @exercise_history.exercise_id
    fill_in "Reps", with: @exercise_history.reps
    fill_in "Sets", with: @exercise_history.sets
    check "Success" if @exercise_history.success
    fill_in "Weight", with: @exercise_history.weight
    click_on "Update Exercise history"

    assert_text "Exercise history was successfully updated"
    click_on "Back"
  end

  test "should destroy Exercise history" do
    visit exercise_history_url(@exercise_history)
    click_on "Destroy this exercise history", match: :first

    assert_text "Exercise history was successfully destroyed"
  end
end
