class AddProductIdToPack < ActiveRecord::Migration[5.2]
  def change
    add_column :packs, :product_id, :integer
  end
end
