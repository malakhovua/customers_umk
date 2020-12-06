class AddPackTypeIdToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :pack_type_id, :integer
  end
end
