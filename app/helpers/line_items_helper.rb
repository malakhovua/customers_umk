module LineItemsHelper
  def display_recount(number)
    unless number.nil?
      sprintf("%01.2f",number)
    end
  end
end
