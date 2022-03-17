class CreateRaces < ActiveRecord::Migration[7.0]
  def change
    create_table :races do |t|
      t.string :name
      t.string :buff
      t.integer :additional_buff

      t.timestamps
    end
  end
end
