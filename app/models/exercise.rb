class Exercise < ApplicationRecord
  include ExerciseSchemes

  belongs_to :category
  has_many :exercise_histories, dependent: :destroy
end
