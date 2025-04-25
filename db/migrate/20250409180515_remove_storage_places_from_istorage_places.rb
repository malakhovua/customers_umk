class RemoveStoragePlacesFromIstoragePlaces < ActiveRecord::Migration[5.2]
  def change
    remove_reference :inventories, :storage_places, foreign_key: true
  end
end
