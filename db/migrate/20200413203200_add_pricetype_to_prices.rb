class AddPricetypeToPrices < ActiveRecord::Migration[5.2]
  def change
    add_reference :prices, :pricetype, foreign_key: true
  end
end
