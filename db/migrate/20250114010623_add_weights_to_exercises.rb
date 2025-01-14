class AddWeightsToExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :exercises, :weight, :integer
    add_column :exercises, :progression, :integer
  end
end
