class ChangeDefaultStickValueCarts < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:carts, :stick, false )
  end
end
