class AddTitleToStoragePlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :storage_places, :title, :string
  end
end
