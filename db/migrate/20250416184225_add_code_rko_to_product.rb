class AddCodeRkoToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :rko, :decimal
  end
end
