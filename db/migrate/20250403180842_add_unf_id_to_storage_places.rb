class AddUnfIdToStoragePlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :storage_places, :unf_id, :string
  end
end
