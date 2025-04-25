class AddUnfIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :unf_id, :string
  end
end
