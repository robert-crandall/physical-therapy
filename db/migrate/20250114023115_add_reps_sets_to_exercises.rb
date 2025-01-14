class AddRepsSetsToExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :exercises, :reps, :integer
    add_column :exercises, :sets, :integer
    add_column :exercises, :duration_seconds, :integer
    add_column :exercises, :rest_seconds, :integer

    # First update existing records
    Exercise.where(lift_scheme: nil).update_all(lift_scheme: 0)

    # Then change column constraints
    change_column :exercises, :lift_scheme, :integer, default: 0, null: false
  end
end
