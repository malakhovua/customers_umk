class AddIsFolderToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :is_folder, :boolean, default: false
  end
end
