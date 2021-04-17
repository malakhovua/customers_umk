class AddClientToCart < ActiveRecord::Migration[5.2]
  def change
    add_reference :carts, :client, foreign_key: true
  end
end
