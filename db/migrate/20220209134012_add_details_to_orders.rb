class AddDetailsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :pickup, :boolean, default: false
    add_column :orders, :certificate, :boolean, default: false
    add_column :orders, :postponement, :boolean, default: false
    add_column :orders, :return, :boolean, default: false
    add_column :orders, :return_item, :boolean, default: false
  end
end
