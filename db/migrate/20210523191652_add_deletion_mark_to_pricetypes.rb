class AddDeletionMarkToPricetypes < ActiveRecord::Migration[5.2]
  def change
    add_column :pricetypes, :deletion_mark, :boolean
  end
end
