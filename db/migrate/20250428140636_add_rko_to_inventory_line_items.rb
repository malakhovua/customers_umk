class AddRkoToInventoryLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_line_items, :rko, :decimal
  end
end
