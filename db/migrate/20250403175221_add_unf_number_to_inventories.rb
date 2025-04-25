class AddUnfNumberToInventories < ActiveRecord::Migration[5.2]
  def change
    add_column :inventories, :unf_number, :string
  end
end
