class RemovePricetypeToBeReferenceInPrices < ActiveRecord::Migration[5.2]
  def change
    remove_column :prices, :pricetype_id, :integer
  end
end
