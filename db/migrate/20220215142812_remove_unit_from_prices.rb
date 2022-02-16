class RemoveUnitFromPrices < ActiveRecord::Migration[5.2]
  def change
    remove_column :prices, :unit_id
  end
end
