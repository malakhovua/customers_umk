class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :client, foreign_key: true
      t.date :date
      t.text :shipping_address
      t.references :user, foreign_key: true
      t.text :comments

      t.timestamps
    end
  end
end
