class CreatePricetypes < ActiveRecord::Migration[5.2]
  def change
    create_table :pricetypes do |t|
      t.string :name

      t.timestamps
    end
  end
end
