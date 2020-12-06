class AddStickToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :stick, :boolean
  end
end
