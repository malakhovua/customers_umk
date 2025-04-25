class AddUnitProductToInventoryLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :inventory_line_items, :unit_product, foreign_key: true
  end
end
