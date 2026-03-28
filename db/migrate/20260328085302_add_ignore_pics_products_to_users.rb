class AddIgnorePicsProductsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ignore_pics_products, :boolean
  end
end
