class ChangeLineItemsTypeForQuantity < ActiveRecord::Migration[5.2]
  def up
    change_column :line_items, :quantity, :float, default: 0.0
  end

  def down
    change_column :line_items, :quantity, :integer, default: 1
  end
end


