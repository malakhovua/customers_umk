class AddWeightToPacks < ActiveRecord::Migration[5.2]
  def change
    add_column :packs, :weight, :float
  end
end
