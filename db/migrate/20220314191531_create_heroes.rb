class CreateHeroes < ActiveRecord::Migration[7.0]
  def change
    create_table :heroes do |t|
      t.string :name
      t.string :race
      t.integer :power
      t.integer :defense

      t.timestamps
    end
  end
end
