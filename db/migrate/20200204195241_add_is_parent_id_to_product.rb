class AddIsParentIdToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :parent_id, :integer
  end
end
