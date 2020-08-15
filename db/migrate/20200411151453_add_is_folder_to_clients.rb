class AddIsFolderToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :is_folder, :boolean
  end
end
