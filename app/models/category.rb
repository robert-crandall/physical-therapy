class Category < ApplicationRecord
  has_many :exercises

  def next_exercises
    exercises
      .left_joins(:exercise_histories)
      .select("exercises.*, MAX(exercise_histories.created_at) as last_completed")
      .group("exercises.id")
      .order(Arel.sql("last_completed ASC NULLS FIRST"))
      .limit(remaining_quality)
  end

  private

  def remaining_quality
    quantity - recently_completed_exercises.count
  end

  def recently_completed_exercises
    exercise_history.where("created_at > ?", 2.hours.ago).limit(quantity)
  end

  def exercise_history
    ExerciseHistory.where(exercise: self.exercises).order(created_at: :desc)
  end
end
