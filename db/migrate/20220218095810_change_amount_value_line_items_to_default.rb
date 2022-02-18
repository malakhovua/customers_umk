class ChangeAmountValueLineItemsToDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :line_items,:amount,0.0
  end
end
