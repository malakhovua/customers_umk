class AddStickToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :stick, :boolean, default: false
  end
end
