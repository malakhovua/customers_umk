class AddPackRefToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :pack, foreign_key: true
  end
end
