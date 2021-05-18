class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :description
      t.belongs_to :client, foreign_key: true

      t.timestamps
    end
  end
end
