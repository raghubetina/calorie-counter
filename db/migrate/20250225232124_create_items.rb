class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :photo
      t.integer :calories
      t.integer :carbs
      t.integer :protein
      t.integer :fat
      t.text :comment

      t.timestamps
    end
  end
end
