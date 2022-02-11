class AddColumnToExchNode < ActiveRecord::Migration[5.2]
  def change
    add_column :exch_nodes, :code_unf, :string
  end
end
