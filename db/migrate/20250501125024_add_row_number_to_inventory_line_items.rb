class AddRowNumberToInventoryLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_line_items, :row_number, :decimal
  end
end
