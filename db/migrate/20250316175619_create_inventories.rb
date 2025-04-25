class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.references :storage_places, foreign_key: true
      t.references :user, foreign_key: true
      t.datetime :date
      t.string :desc
      t.timestamps
    end
  end
end
