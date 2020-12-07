class CreateExchNodes < ActiveRecord::Migration[5.2]
  def change
    create_table :exch_nodes do |t|
      t.string :node
      t.string :ser
      t.string :cat

      t.timestamps
    end
  end
end
