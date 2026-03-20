class ChangeColumnSessionIdTypeInCart < ActiveRecord::Migration[5.2]
  def change
    change_column :carts, :session_id, :string
  end
end
