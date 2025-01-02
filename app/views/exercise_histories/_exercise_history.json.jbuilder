json.extract! exercise_history, :id, :exercise_id, :sets, :reps, :weight, :success, :created_at, :updated_at
json.url exercise_history_url(exercise_history, format: :json)
