class ChangeLineItemsToBeNullInCart < ActiveRecord::Migration[5.2]
  def change
    change_column_null :line_items, :cart_id,true
  end
end
