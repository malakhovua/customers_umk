class AddCheckedToInventoryLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :inventory_line_items, :checked, :boolean, default: false
  end
end
