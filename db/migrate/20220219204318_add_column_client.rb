class AddColumnClient < ActiveRecord::Migration[5.2]
  def change
    add_reference :clients, :access_group, foreign_key: true
  end
end
