class AddTypeIdToPack < ActiveRecord::Migration[5.2]
  def change
    add_column :packs, :type_id, :integer
  end
end
