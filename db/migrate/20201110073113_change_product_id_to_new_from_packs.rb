class ChangeProductIdToNewFromPacks < ActiveRecord::Migration[5.2]
  def change
    change_table :packs do |table|
      table.change :product_id, :string
    end
  end
end
