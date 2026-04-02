class ApplicationJob < ActiveJob::Base

  def delete_old_empty_carts

    Cart.left_joins(:line_items)
        .where("carts.created_at < ?", 1.day.ago)
        .where(line_items: { id: nil })
        .destroy_all

  end

end
