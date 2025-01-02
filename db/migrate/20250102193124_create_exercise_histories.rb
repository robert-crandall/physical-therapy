class CreateExerciseHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :exercise_histories do |t|
      t.references :exercise, null: false, foreign_key: true
      t.integer :sets
      t.integer :reps
      t.integer :weight
      t.boolean :success

      t.timestamps
    end
  end
end
