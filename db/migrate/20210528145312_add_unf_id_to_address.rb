class AddUnfIdToAddress < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :unf_id, :string
  end
end
