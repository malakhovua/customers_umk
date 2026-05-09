class AddShowAsListOnDesktopToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :show_as_list_on_desktop, :boolean, default: false, null: false
  end
end
