class AddFullNameToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :full_name, :string
  end
end
