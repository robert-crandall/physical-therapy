require "test_helper"

class ExerciseHistoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exercise_history = exercise_histories(:one)
  end

  test "should get index" do
    get exercise_histories_url
    assert_response :success
  end

  test "should get new" do
    get new_exercise_history_url
    assert_response :success
  end

  test "should create exercise_history" do
    assert_difference("ExerciseHistory.count") do
      post exercise_histories_url, params: { exercise_history: { exercise_id: @exercise_history.exercise_id, reps: @exercise_history.reps, sets: @exercise_history.sets, success: @exercise_history.success, weight: @exercise_history.weight } }
    end

    assert_redirected_to exercise_history_url(ExerciseHistory.last)
  end

  test "should show exercise_history" do
    get exercise_history_url(@exercise_history)
    assert_response :success
  end

  test "should get edit" do
    get edit_exercise_history_url(@exercise_history)
    assert_response :success
  end

  test "should update exercise_history" do
    patch exercise_history_url(@exercise_history), params: { exercise_history: { exercise_id: @exercise_history.exercise_id, reps: @exercise_history.reps, sets: @exercise_history.sets, success: @exercise_history.success, weight: @exercise_history.weight } }
    assert_redirected_to exercise_history_url(@exercise_history)
  end

  test "should destroy exercise_history" do
    assert_difference("ExerciseHistory.count", -1) do
      delete exercise_history_url(@exercise_history)
    end

    assert_redirected_to exercise_histories_url
  end
end
