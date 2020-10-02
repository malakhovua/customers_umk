class AddParentNameToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :parent_name, :string
  end
end
