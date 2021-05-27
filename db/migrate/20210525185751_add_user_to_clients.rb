class AddUserToClients < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :clients, :user, polymorphic: true
  end
end
