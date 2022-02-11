class AddUnitProductToPrices < ActiveRecord::Migration[5.2]
  def change
    add_reference :prices, :unit, foreign_key: true
  end
end
