class CreateFavoriteProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_products do |t|
      t.references :user, foreign_key: true
      t.belongs_to :product, foreign_key: true

      t.timestamps
    end
  end
end
