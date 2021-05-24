class AddDeletionMarkToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :deletion_mark, :boolean
  end
end
