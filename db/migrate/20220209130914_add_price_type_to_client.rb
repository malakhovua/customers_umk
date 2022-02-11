class AddPriceTypeToClient < ActiveRecord::Migration[5.2]
  def change
    add_reference :clients, :pricetype, foreign_key: true
  end
end
