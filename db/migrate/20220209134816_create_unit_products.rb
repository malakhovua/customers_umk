class CreateUnitProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :unit_products do |t|
      t.string :name
      t.boolean :default
      t.belongs_to :product

      t.timestamps
    end
  end
end
