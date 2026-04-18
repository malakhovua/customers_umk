class AddUpdateRegularlyToPricetypes < ActiveRecord::Migration[5.2]
  def change
    add_column :pricetypes, :update_regularly, :boolean
  end
end
