class RemoveBuffAndAdditionalBuffFromRace < ActiveRecord::Migration[7.0]
  def change
    remove_column :races, :buff
    remove_column :races, :additional_buff
    add_column :races, :buff_type, :string
    add_column :races, :buff_quantity, :integer
  end
end
