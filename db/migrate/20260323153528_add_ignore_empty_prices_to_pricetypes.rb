class AddIgnoreEmptyPricesToPricetypes < ActiveRecord::Migration[5.2]
  def change
    add_column :pricetypes, :ignore_empty_prices, :boolean
  end
end
