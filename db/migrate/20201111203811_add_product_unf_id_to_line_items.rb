class AddProductUnfIdToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :product_unf_id, :string
  end
end
