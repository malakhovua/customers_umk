class ChangeColumnProductException < ActiveRecord::Migration[5.2]
  def change
    remove_columns :product_exeptions, :clients_id, :products_id
    add_reference :product_exeptions, :product, foreign_key: true
    add_reference :product_exeptions, :client, foreign_key: true
  end
end
