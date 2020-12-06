class Add1cIdToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :unf_id, :string
  end
end
