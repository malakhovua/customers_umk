class AddProductToPrices < ActiveRecord::Migration[5.2]
  def change
    add_reference :prices, :product, foreign_key: true
  end
end
