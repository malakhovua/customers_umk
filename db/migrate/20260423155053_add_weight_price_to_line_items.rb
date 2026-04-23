class AddWeightPriceToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :weight_price, :float, default: 0.0, null: false
  end
end
