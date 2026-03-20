class AddPriceToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :price, :float, default: 0.0, null: false
  end
end
