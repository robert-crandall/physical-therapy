class AddSequencePositionToExerciseHistories < ActiveRecord::Migration[8.0]
  def change
    add_column :exercise_histories, :sequence_position, :integer, default: 0, null: false
  end
end
