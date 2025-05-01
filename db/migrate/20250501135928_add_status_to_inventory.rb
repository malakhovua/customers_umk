class AddStatusToInventory < ActiveRecord::Migration[5.2]
  def change
    add_column :inventories, :status, :integer
  end
end
