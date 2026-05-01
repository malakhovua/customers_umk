require 'faraday'
require 'faraday_middleware'
require 'json'
require 'base64'

class Unf

  def get_all_data

    get_access_groups
    get_price_types
    get_clients
    get_addresses
    get_products
    get_packs
    get_prices
    get_product_exceptions_1c83

  end
  def get_products

    res = connect_1c.get(get_unf_path('products'))

    data = JSON.parse res.body

    data.each { |dt|
      prod = if Product.where(:unf_id => dt['unf_id']).present?
               Product.find_by(unf_id: dt['unf_id'])
             else
               Product.new
             end

      prod[:unf_id] = dt['unf_id']
      prod[:deletion_mark] = dt['deletion_mark']
      prod[:not_active] = dt['not_active']
      prod[:unf_parent_id] = dt['unf_parent_id']
      prod[:title] = dt['title']
      prod[:description] = 'description'
      prod[:full_name] = dt['full_name']
      prod[:order_id] = dt['order_id']
      prod[:is_folder] = dt['is_folder']
      prod[:parent_name] = dt['parent_name']
      prod[:weight] = dt['weight']
      prod[:created_at] = Time.now

      if dt['binary_file'] == ''
        prod.image_url = 'image_url.jpg'
      else
        base64_image = dt['binary_file']
        # decode64
        img_from_base64 = Base64.decode64(base64_image)
        # file type
        filetype = dt['file_extension']
        # name the file
        filename = './app/assets/images/' + prod['unf_id']

        # write file
        file = filename << '.' << filetype
        File.open(file, 'wb') do |f|
          f.write(img_from_base64)
        end
        prod.image_url = dt['unf_id'] + '.' + filetype
      end
      # end file
      prod.image_url = 'folder.jpg' if prod[:is_folder] == true

      begin
        prod.save
      rescue Exception => e
        puts "An error occurred: #{e.message}"
      end

      # create product units
      data_inits = dt['units']
      data_inits.each do |dt_unit|
        unit = if UnitProduct.where(:unf_id => dt_unit['unf_id']).present?
                 UnitProduct.find_by(unf_id: dt_unit['unf_id'])
               else
                 UnitProduct.new
               end
        unit['unf_id'] = dt_unit['unf_id']
        unit['name'] = dt_unit['name']
        unit['deletion_mark'] = dt_unit['deletion_mark']
        unit['ratio'] = dt_unit['ratio']
        unit['weight']= dt_unit['weight']
        unit['default'] = dt_unit['default']
        unit['product_id'] = prod.id
        unit.save
      end
      # end product units
    }

     connect_1c.get(get_unf_path('delete_registration','2'))

  end

  def get_packs
    res = connect_1c.get(get_unf_path('packs'))

    data = JSON.parse res.body

    data.each { |dt|
      pack = if Pack.where(:id => dt['id'].to_i).present?
               Pack.find_by(id: dt['id'].to_i)
             else
               Pack.new
             end

      pack[:id] = dt['id'].to_i
      pack[:type_id] = dt['type_id'].to_i
      pack[:deletion_mark] = dt['deletion_mark']
      pack[:name] = dt['name']
      pack[:description] = dt['description']
      pack[:product_id] = dt['product_id']
      pack[:weight] = dt['weight']
      pack[:not_active] = dt['not_active']
      pack[:created_at] = Time.now
      pack.save
    }

    connect_1c.get(get_unf_path('delete_registration','3'))

  end

  def get_clients
    res = connect_1c.get(get_unf_path('clients'))

    data = JSON.parse res.body

    data.each { |dt|
      client = if Client.where(:unf_id => dt['unf_id']).present?
                 Client.find_by(unf_id: dt['unf_id'])
               else
                 Client.new
               end

      client[:unf_id] = dt['unf_id']
      client[:access_group_id] = dt['access_group_id'].to_i != 0 ? dt['access_group_id'].to_i : ""
      client[:parent_id] = dt['parent_id']
      client[:pricetype_id] = dt['pricetype_id']
      client[:deletion_mark] = dt['deletion_mark']
      client[:parent_name] = dt['parent_name']
      client[:name] = dt['name']
      client[:address] = dt['address']
      client[:email] = dt['email']
      client[:phone] = dt['phone']
      client[:is_folder] = dt['is_folder']
      client[:not_active] = dt['not_active']
      client[:created_at] = Time.now
      client.save
    }

    connect_1c.get(get_unf_path('delete_registration','4'))

  end

  def get_regular_prices
    regular_update_price_types =  Pricetype.where(update_regularly: true)

    regular_update_price_types.each do |rt|
      get_prices_common(rt.id.to_s.rjust(9,'0'))
    end

  end

  def get_prices
    get_prices_common
  end

  def get_prices_common (price_type_id = '')

    if price_type_id.empty?
      res = connect_1c.get(get_unf_path('price'))
    else
      res = connect_1c.get(get_unf_path('regular_price', price_type_id))
    end

    data = JSON.parse res.body

    data.each { |dt|
      product = Product.find_by(:unf_id => dt['unf_id'])
      if product.nil?
        next
      else
        price = if Price.where(:product_id => product.id, :pricetype_id => dt['pricetype_id'],
                               :period => dt['period']).present?
                  Price.find_by(:product_id => product.id, :pricetype_id => dt['pricetype_id'], :period => dt['period'])
                else
                  Price.new
                end
      end

      price[:pricetype_id] = dt['pricetype_id']
      unit = UnitProduct.find_by(:unf_id => dt['unit_id'])
      price[:unit_product_id] = unit.nil? ? '' : unit.id
      price[:period] = dt['period']
      price[:product_id] = Product.find_by(unf_id: dt['unf_id']).id
      unless dt['unf_pack_id'] == ''
        pack = Pack.find_by(id: dt['unf_pack_id'])
        next if pack.nil?

        price[:pack_id] = dt['unf_pack_id']
      end
      price[:value] = dt['value']
      price[:created_at] = Time.now

      price.save!
    }

    connect_1c.get(get_unf_path('delete_registration','7'))

  end

  def get_addresses
    res = connect_1c.get(get_unf_path('addresses'))

    data = JSON.parse res.body

    data.each { |dt|
      addr = if Address.where(:unf_id => dt['unf_id']).present?
               Address.find_by(unf_id: dt['unf_id'])
             else
               Address.new
             end

      client = Client.find_by(unf_id: dt['owner_id'])
      next if client.nil?

      addr[:client_id] = client.id
      addr[:unf_id] = dt['unf_id']
      addr[:name] = dt['name']
      addr[:description] = dt['Description']
      addr[:deletion_mark] = dt['deletion_mark']
      addr[:created_at] = Time.now
      addr.save!
    }

    connect_1c.get(get_unf_path('delete_registration','5'))

  end

  def get_access_groups
    res = connect_1c.get(get_unf_path('access_groups'))

    data = JSON.parse res.body

    data.each { |dt|
      group = if AccessGroup.where(:id => dt['id'].to_i).present?
                AccessGroup.find_by(id: dt['id'].to_i)
             else
               AccessGroup.new
             end

      group[:id] = dt['id'].to_i
      group[:name] = dt['name']
      group.save!
    }

    connect_1c.get(get_unf_path('delete_registration','1'))

  end

  def get_price_types
    res = connect_1c.get(get_unf_path('pricetype'))

    data = JSON.parse res.body

    data.each { |dt|
      pricetype = if Pricetype.where(:id => dt['id']).present?
                    Pricetype.find_by(id: dt['id'])
                  else
                    Pricetype.new
                  end

      pricetype[:id] = dt['id']
      pricetype[:deletion_mark] = dt['deletion_mark']
      pricetype[:name] = dt['name']
      pricetype.save!
    }

    connect_1c.get(get_unf_path('delete_registration','6'))

  end

  def get_product_exceptions_1c83

    res = connect_1c.get(get_unf_path('product_exceptions'))

    data = JSON.parse res.body

    data.each { |dt|

      product = Product.find_by(:unf_id => dt['product_id'])
      client = Client.find_by(:unf_id => dt['client_id'])

      unless product.present? && client.present?
        next
      end

      if ProductExeption.where(:product_id => product.id, :client_id => client.id).present?
        next
      else
        exception = ProductExeption.new
      end

      exception.product_id = product.id
      exception.client_id = client.id

      exception.save!
    }

    connect_1c.get(get_unf_path('delete_registration','8'))

  end

  def connect_1c
    conn = Faraday.new
    conn.options.timeout = 200
    conn.basic_auth('admin', 'wY7mixap')
    conn.response :json, :content_type => /\bjson$/
    conn
  end

  def clear_img_url
    products = Product.all
    products.each do |prod|
      prod[:image_url] = 'image_url.jpg'
      prod.save
    end
  end


  def get_expense_invoices

    res = connect_1c.get(get_unf_path('expense_invoices'))

    data = JSON.parse res.body

    data.each { |dt|

      expense_invoice =
        if ExpenseInvoice.find_by(:number => dt['number'], :doc_date => dt['doc_date']).present?
          ExpenseInvoice.find_by(:number => dt['number'], :doc_date => dt['doc_date'])
        else
          ExpenseInvoice.new
        end

      expense_invoice['access_group_id'] = dt['access_group_id'].to_i if dt['access_group_id'].present?

      client = Client.find_by(:unf_id => dt['client_id'])

      unless client.present?

        client =   Client.new
        client.name = dt['client_name']
        client.id = dt['id']
        client.unf_id = dt['unf_id']
        client.save!

      end

      expense_invoice['client_id'] = client&.id
      expense_invoice['order_id'] = dt['order_id'].to_i if dt['order_id'].present?
      expense_invoice['doc_type'] = dt['doc_type'].to_i
      expense_invoice['sum'] = dt['sum'].to_f
      expense_invoice['retail_sum'] = dt['retail_sum'].to_f
      expense_invoice['number'] = dt['number']
      expense_invoice['doc_date'] = dt['doc_date']
      expense_invoice['comment'] = dt['comment']
      expense_invoice.save!

      expense_invoice.line_item_expense_invoices.destroy_all

      dt['line_items'].each { |itm|

        line_item = LineItemExpenseInvoice.new

        line_item['product_id'] =  Product.find_by(:unf_id => itm['product_id'])&.id
        line_item['pack_id'] = itm['puck_id'].to_i if itm['puck_id'].present?

        prod = Product.find_by(unf_id: dt['unf_id'])

        unless Product.where(unf_id: itm['unf_id']).present?
          prod = Product.new
          prod.params_json_to_object(itm)
          prod.save!
        end

        line_item['unit_product_id'] = prod&.id
        line_item['qty'] = itm['qty'].to_f
        line_item['price'] = itm['price'].to_f
        line_item['retail_price'] = itm['retail_price'].to_f
        line_item['sum'] = itm['sum_itm'].to_f
        line_item['retail_sum'] = itm['retail_sum_itm'].to_f
        line_item['comment'] = itm['comment_itm']
        line_item['expense_invoice_id'] = expense_invoice.id
        line_item.save!

      }


    }

    connect_1c.get(get_unf_path('delete_registration','10'))



  end

  def post_orders(date1="", date2="", user_id="",all_orders = false)

    if all_orders
      orders = Order.all.where(server_unf: nil)
    else
      orders = Order.all.where(date: date1..date2, server_unf: nil, user_id: user_id)
    end


    orders_data = orders.map do |order|
      {
        header: order,
        clien_unf_id: order.client['unf_id'].to_s,
        address_id: order.address&.unf_id || '',
        line_items: order.line_items
      }
    end

    payload = { orders: orders_data }.to_json

    resp = connect_1c.post(
      get_unf_path('orders'),
      payload,
      'Content-Type' => 'application/json'
    )

    update_orders(resp) if resp
    resp
  end

  def update_orders(resp)
    data = JSON.parse(resp.body)

    data.each do |dt|
      order = Order.find_by(id: dt['id'])
      next unless order

      order.server_unf = dt['server_unf']
      order.server_unf_date = dt['server_unf_date']
      order.save!
    end
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse order response: #{e.message}")
    nil
  end

  def get_unf_path(method, param = '')
    unf_base = ExchNode.first();
    path_string = unf_base.ser + '/' + unf_base.cat + '/' + method + '/' + unf_base.code_unf + '/' + param
    path_string
  end
end
