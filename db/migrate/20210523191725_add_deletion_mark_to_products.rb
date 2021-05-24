class AddDeletionMarkToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :deletion_mark, :boolean
  end
end
