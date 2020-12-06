class Add1cParentIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :unf_parent_id, :string
  end
end
