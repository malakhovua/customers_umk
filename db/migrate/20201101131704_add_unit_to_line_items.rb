class AddUnitToLineItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :line_items, :unit, foreign_key: true
  end
end
