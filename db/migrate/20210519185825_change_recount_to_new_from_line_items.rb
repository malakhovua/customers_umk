class ChangeRecountToNewFromLineItems < ActiveRecord::Migration[5.2]
  def change
      change_table :line_items do |table|
        table.change :recount, :float
      end
  end
end
