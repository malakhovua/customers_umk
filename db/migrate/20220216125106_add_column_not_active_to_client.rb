class AddColumnNotActiveToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :not_active, :boolean, default: false
  end
end
