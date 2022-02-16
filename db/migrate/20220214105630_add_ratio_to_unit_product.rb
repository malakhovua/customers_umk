class AddRatioToUnitProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :unit_products, :ratio, :float, default: 1.00
  end
end
