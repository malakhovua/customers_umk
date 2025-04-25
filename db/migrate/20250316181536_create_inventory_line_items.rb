class CreateInventoryLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_line_items do |t|
      t.references :product, foreign_key: true
      t.float :qty
      t.float :price
      t.float :sum
      t.string :comment
      t.belongs_to :inventory, foreign_key: true

      t.timestamps
    end
  end
end
