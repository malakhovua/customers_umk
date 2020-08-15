class AddPackToPrices < ActiveRecord::Migration[5.2]
  def change
    add_reference :prices, :pack, foreign_key: true
  end
end
