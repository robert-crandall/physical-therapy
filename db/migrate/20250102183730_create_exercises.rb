class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :image
      t.string :link
      t.references :category, null: false, foreign_key: true
      t.integer :lift_scheme

      t.timestamps
    end
  end
end
