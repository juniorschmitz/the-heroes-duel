class CreateDuels < ActiveRecord::Migration[7.0]
  def change
    create_table :duels do |t|
      t.integer :id_hero_1
      t.integer :id_hero_2

      t.timestamps
    end
  end
end
