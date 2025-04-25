class AddSumToInventories < ActiveRecord::Migration[5.2]
  def change
    add_column :inventories, :sum, :float
  end
end
