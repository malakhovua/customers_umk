class ChangeUnitProductDefaull < ActiveRecord::Migration[5.2]
  def change
    change_column :unit_products, :default, :boolean, default: false
  end
end
