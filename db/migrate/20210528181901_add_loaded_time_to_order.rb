class AddLoadedTimeToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :server_unf_date, :datetime
  end
end
