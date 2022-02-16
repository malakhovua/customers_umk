class RemoveReferenceUnitProductFromPrices < ActiveRecord::Migration[5.2]
  def change
    remove_column :prices, :unit_product_id
  end
end
