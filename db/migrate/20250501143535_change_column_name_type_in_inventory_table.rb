class ChangeColumnNameTypeInInventoryTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :inventories, :type, :inv_type
  end
end
