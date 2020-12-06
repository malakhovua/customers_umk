class AddPartentNameToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :parent_name, :string
  end
end
