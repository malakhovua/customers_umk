class AddClientReferenceToFavoriteProducts < ActiveRecord::Migration[5.2]
  def change
    add_reference :favorite_products, :client, foreign_key: true
  end
end
