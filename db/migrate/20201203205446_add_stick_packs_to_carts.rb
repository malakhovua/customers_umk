class AddStickPacksToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :stick_pack, :boolean, default: false
  end
end
