class AddRaceClassToHeroes < ActiveRecord::Migration[7.0]
  def change
    add_reference :heroes, :race, foreign_key: true
  end
end
