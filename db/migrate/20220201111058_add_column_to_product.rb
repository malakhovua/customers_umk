class AddColumnToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :not_active, :boolean, default: false
  end
end
