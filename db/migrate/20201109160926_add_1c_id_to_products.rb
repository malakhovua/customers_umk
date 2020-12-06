class Add1cIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :unf_id, :string
  end
end
