class AddDeletionMarkToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :deletion_mark, :boolean
  end
end
