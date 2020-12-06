class AddStickPacksToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :stick_pack, :boolean, default: false
  end
end
