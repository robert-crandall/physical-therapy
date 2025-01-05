class Exercise < ApplicationRecord
  belongs_to :category
  has_many :exercise_histories, dependent: :destroy
end
