class AddShowAsCardsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :show_as_cards, :boolean, default: false, null: false
  end
end
