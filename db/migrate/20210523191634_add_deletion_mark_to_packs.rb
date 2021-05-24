class AddDeletionMarkToPacks < ActiveRecord::Migration[5.2]
  def change
    add_column :packs, :deletion_mark, :boolean
  end
end
