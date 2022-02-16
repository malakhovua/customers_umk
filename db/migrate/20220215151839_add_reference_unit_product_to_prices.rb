class AddReferenceUnitProductToPrices < ActiveRecord::Migration[5.2]
  def change
    add_reference :prices, :unit_product, foreign_key: true
  end
end
