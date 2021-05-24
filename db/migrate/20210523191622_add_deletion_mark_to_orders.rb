class AddDeletionMarkToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :deletion_mark, :boolean
  end
end
