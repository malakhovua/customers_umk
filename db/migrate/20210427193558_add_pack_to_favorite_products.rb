class AddPackToFavoriteProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :favorite_products, :pack, foreign_key: true 
  end
end
