class AddIgnoreNotActivePacksToPricetypes < ActiveRecord::Migration[5.2]
  def change
    add_column :pricetypes, :ignore_not_active_packs, :boolean
  end
end
