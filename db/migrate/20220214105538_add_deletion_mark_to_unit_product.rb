class AddDeletionMarkToUnitProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :unit_products, :deletion_mark, :boolean, default: false
  end
end
