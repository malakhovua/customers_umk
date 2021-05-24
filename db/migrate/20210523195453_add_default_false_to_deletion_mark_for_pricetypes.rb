class AddDefaultFalseToDeletionMarkForPricetypes < ActiveRecord::Migration[5.2]
  def change
    change_column_default :pricetypes, :deletion_mark, from: nil, to: false
  end
end
