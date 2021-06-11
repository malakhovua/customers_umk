class CreateAsighnclients < ActiveRecord::Migration[5.2]
  def change
    create_table :asighnclients do |t|
      t.references :user, foreign_key: true
      t.references :client, foreign_key: true
      t.timestamps
    end
  end
end
