class AddDisplacementStorageRecipientToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :displacement, :boolean
    add_column :orders, :recipient_storage_place_id, :integer
  end
end
