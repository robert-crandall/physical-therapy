class Exercise < ApplicationRecord
  include ExerciseSchemes

  belongs_to :category
  has_many :exercise_histories, dependent: :destroy

  validate :duration_long_enough

  private

  def duration_long_enough
    return unless duration.present?

    if reps.present?
      errors.add(:base, "Cannot have both reps and duration. Choose reps if duration is less than 10 seconds.")
    end

    if duration.to_i < 10
      errors.add(:base, "Duration must be at least 10 seconds. Choose reps if duration is less than 10 seconds.")
    end
  end
end
