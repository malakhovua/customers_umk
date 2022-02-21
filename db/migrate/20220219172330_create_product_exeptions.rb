class CreateProductExeptions < ActiveRecord::Migration[5.2]
  def change
    create_table :product_exeptions do |t|
      t.references :products, foreign_key: true
      t.references :clients, foreign_key: true

      t.timestamps
    end
  end
end
