class AddUnfIdToUnitProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :unit_products, :unf_id, :string
  end
end
