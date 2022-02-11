class AddUnfIdToPriceType < ActiveRecord::Migration[5.2]
  def change
    add_column :pricetypes, :unf_id, :string
  end
end
