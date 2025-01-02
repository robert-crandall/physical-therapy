class Category < ApplicationRecord
  has_many :exercises

  def next_exercise
    exercises.first # Later can add logic for progression
  end
end
