class AddDefaultFalseToDeletionMarkForAddresses < ActiveRecord::Migration[5.2]
  def change
    change_column_default :addresses, :deletion_mark, from: nil, to: false
  end
end
