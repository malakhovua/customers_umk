class CreateStoragePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :storage_places do |t|

      t.timestamps
    end
  end
end
