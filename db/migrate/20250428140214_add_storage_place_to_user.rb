class AddStoragePlaceToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :storage_place, foreign_key: true
  end
end
