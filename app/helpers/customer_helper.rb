module CustomerHelper
  def current_client_id
    if @cart.nil?
      nil
    else
      @cart.client_id
    end
  end
end
