class AddPricetypeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :pricetype_id, :integer
  end
end
