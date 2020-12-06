class AddAmountToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :amount, :integer
  end
end
