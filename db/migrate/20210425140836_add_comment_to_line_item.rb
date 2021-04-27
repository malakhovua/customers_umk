class AddCommentToLineItem < ActiveRecord::Migration[5.2]
  def change
    add_column :line_items, :comment, :string
  end
end
