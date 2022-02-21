class CreateAccessGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :access_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
