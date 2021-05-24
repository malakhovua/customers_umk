class AddDefaultFalseToDeletionMarkForPacks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :packs, :deletion_mark, from: nil, to: false
  end
end
