class AddLoadedToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :server_unf, :boolean
  end
end
