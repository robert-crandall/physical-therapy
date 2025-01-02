class Category < ApplicationRecord
  has_many :exercises

  def next_exercise
    exercises
      .where.not(id: exercise_history.select(:exercise_id))
      .first || exercises.first # If all completed, start over
  end

  private

  def exercise_history
    ExerciseHistory.where(exercise: self.exercises)
  end
end
