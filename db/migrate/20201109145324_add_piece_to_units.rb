class AddPieceToUnits < ActiveRecord::Migration[5.2]
  def change
    add_column :units, :piece, :boolean
  end
end
