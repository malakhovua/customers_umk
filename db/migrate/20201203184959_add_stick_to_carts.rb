class AddStickToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :stick, :boolean
  end
end
