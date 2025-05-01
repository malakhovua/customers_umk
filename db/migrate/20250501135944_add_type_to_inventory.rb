class AddTypeToInventory < ActiveRecord::Migration[5.2]
  def change
    add_column :inventories, :type, :integer
  end
end
