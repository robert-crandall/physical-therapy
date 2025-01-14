class AddDescriptionToExercises < ActiveRecord::Migration[8.0]
  def change
    add_column :exercises, :description, :text
  end
end
