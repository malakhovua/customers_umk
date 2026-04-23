class AddWeightToUnitProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :unit_products, :weight, :float, default: 1.0, null: false
  end
end
