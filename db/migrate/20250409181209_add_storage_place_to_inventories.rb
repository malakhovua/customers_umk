class AddStoragePlaceToInventories < ActiveRecord::Migration[5.2]
  def change
    add_reference :inventories, :storage_place, foreign_key: true
  end
end
