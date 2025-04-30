class AddProductNameToInventoryLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_line_items, :product_name, :string
  end
end
