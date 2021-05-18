class AddRecountToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :recount, :integer
  end
end
