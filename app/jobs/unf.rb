require 'faraday'
require 'faraday_middleware'
require 'json'
require 'base64'

class Unf
  def get_products
    res = connect_1c.get(get_unf_path 'products')

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

      if prod['binary_file'] == ''
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

      prod.save

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
        unit['default'] = dt_unit['default']
        unit['product_id'] = prod.id
        unit.save
      end
      # end product units
    }
  end

  def get_packs
    res = connect_1c.get(get_unf_path 'packs')

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
  end

  def get_clients
    res = connect_1c.get(get_unf_path 'clients')

    data = JSON.parse res.body

    data.each { |dt|
      client = if Client.where(:unf_id => dt['unf_id']).present?
                 Client.find_by(unf_id: dt['unf_id'])
               else
                 Client.new
               end

      client[:unf_id] = dt['unf_id']
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
  end

  def get_prices
    res = connect_1c.get(get_unf_path('price'))

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
        pack = Pack.find_by(id:dt['unf_pack_id'])
        next if pack.nil?

        price[:pack_id] = dt['unf_pack_id']
      end
      price[:value] = dt['value']
      price[:created_at] = Time.now

      price.save!
    }
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
  end

  def get_price_types
    res = connect_1c.get(get_unf_path 'pricetype')

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
  end

  def connect_1c
    conn = Faraday.new
    conn.basic_auth('admin', '911*')
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

  def post_orders(date1, date2)
    cont = '{"orders":['

    orders = Order.all.where(:date => date1..date2, :server_unf => nil)
    first = true
    orders.each do |order|
      coma = first ? '' : ','
      cont = cont + coma +
             '{"header":' + order.to_json +
             '"clien_unf_id":' + '"' + order.client['unf_id'].to_s + '"' +
             ',"line_items": [' + order.line_items.to_json + ']' + '}'
      first = false
    end

    cont = cont + ']}'

    resp = connect_1c.post(get_unf_path('orders'), cont,
                           'Content-Type' => 'application/json')
    if resp.nil?
      resp
    else
      update_orders(resp)
    end

    resp
  end

  def update_orders(resp)
    data = JSON.parse resp.body

    data.each { |dt|
      if Order.where(:id => dt['id']).present?
        ord = Order.find_by(id: dt['id'])
        ord[:server_unf] = dt['server_unf']
        ord[:server_unf_date] = dt['server_unf_date']
        ord.save!
      end
    }
  end

  def get_unf_path(method)
    unf_base = ExchNode.first();
    path_string = unf_base.ser + '/' + unf_base.cat + '/' + method + '/' + unf_base.code_unf
    path_string
  end
end
