class ChangeDefaultStickValueLineItems < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:line_items, :stick, false )
  end
end
