class AddPriceTypeIdToPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :prices, :pricetype_id, :integer
  end
end
