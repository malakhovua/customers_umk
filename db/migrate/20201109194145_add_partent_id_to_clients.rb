class AddPartentIdToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :parent_id, :string
  end
end
