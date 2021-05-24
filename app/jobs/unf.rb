require 'faraday'
require 'faraday_middleware'
require 'json'
require 'base64'

class Unf

  def get_products

    res = connect_1c.get(get_unf_path'products')

    data = JSON.parse res.body

    data.each { |p|

      if Product.where(:unf_id => p['unf_id']).present?
        prod = Product.find_by(unf_id: p['unf_id'])
      else
        prod = Product.new
      end

      # prod[:id] = p['id']
      #prod[:parent_id] = p['parent_id'].to_i
      #prod[:price] = 0.01
      prod[:unf_id] = p['unf_id']
      prod[:deletion_mark] = p['deletion_mark'].to_i == 0 ? false : true
      prod[:unf_parent_id] = p['unf_parent_id']
      prod[:title] = p['title']
      prod[:description] = 'description'
      prod[:is_folder] = p['is_folder'].to_i == 0 ? false : true
      prod[:parent_name] = p['parent_name']
      prod[:weight] = p['weight']
      prod[:created_at] = Time.now

      if p['binary_file'] == ''
        prod.image_url = 'image_url.jpg'
      else
        base64_image = p['binary_file']
        # decode64
        img_from_base64 = Base64.decode64(base64_image)
        # file type
        filetype = p['file_extension']
        # name the file
        filename = './app/assets/images/' + p['unf_id']

        # write file
        file = filename << '.' << filetype
        File.open(file, 'wb') do |f|
          f.write(img_from_base64)
        end
        prod.image_url = p['unf_id'] + '.' + filetype
      end
      #end file
      if prod[:is_folder] == true
        prod.image_url = 'folder.jpg'
      end

      prod.save
    }
  end

  def get_packs

    res = connect_1c.get(get_unf_path'packs')

    data = JSON.parse res.body

    data.each { |p|

      if Pack.where(:id => p['id'].to_i).present?
        pack = Pack.find_by(id: p['id'].to_i)
      else
        pack = Pack.new
      end

      pack[:id] = p['id'].to_i
      pack[:type_id] = p['type_id'].to_i
      pack[:deletion_mark] = p['deletion_mark'].to_i == 0 ? false : true
      pack[:name] = p['name']
      pack[:description] = p['description']
      pack[:product_id] = p['product_id']
      pack[:weight] = p['weight']
      pack[:created_at] = Time.now
      pack.save
    }
  end

  def get_clients

    res = connect_1c.get(get_unf_path'clients')

    data = JSON.parse res.body

    data.each { |p|

      if Client.where(:unf_id => p['unf_id']).present?
        client = Client.find_by(unf_id: p['unf_id'])
      else
        client = Client.new
      end

      # client[:id] = p['id'].to_i
      client[:unf_id] = p['unf_id']
      client[:parent_id] = p['parent_id']
      client[:deletion_mark] = p['deletion_mark'].to_i == 0 ? false : true
      client[:parent_name] = p['parent_name']
      client[:name] = p['name']
      client[:address] = p['address']
      client[:email] = p['email']
      client[:phone] = p['phone']
      client[:is_folder] = p['is_folder'].to_i == 0 ? false : true
      client[:created_at] = Time.now
      client.save
    }
  end

  def get_prices

    res = connect_1c.get(get_unf_path("price"))

    data = JSON.parse res.body

    data.each { |p|

      if Price.where(:id => p['id'].to_i).present?
        price = Price.find_by(id: p['id'])
      else
        price = Price.new
      end

      price[:id] = p['id']
      price[:pricetype_id] = p['pricetype_id']

      unless p['pack_id'] = 0
        price[:pack_id] = p['pack_id']
      end
      product = Product.find_by(id: p['product_id'])
      price[:product_id] = p['product_id']
      price[:value] = p['value']
      price[:created_at] = Time.now
      price.save!
    }
  end

  def get_addresses
=begin

    t.string "description"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletion_mark", default: false


    res = connect_1c.get(get_unf_path("addresses"))

    data = JSON.parse res.body

    data.each { |p|

      if Addresses.where(:id => p['id'].to_i).present?
        addr = Price.find_by(id: p['id'])
      else
        addr = Address.new
      end

      addr[:id] = p['unf_id']
      addr
      unless p['pack_id'] = 0
        price[:pack_id] = p['pack_id']
      end
      product = Product.find_by(id: p['product_id'])
      price[:product_id] = p['product_id']
      price[:value] = p['value']
      price[:created_at] = Time.now
      price.save!
    }
=end
  end

  def get_price_types

    res = connect_1c.get(get_unf_path"pricetype")

    data = JSON.parse res.body

    data.each { |p|

      if Pricetype.where(:id => p['id']).present?
        pricetype = Pricetype.find_by(id: p['id'])
      else
        pricetype = Pricetype.new
      end

      pricetype[:id] = p['id']
      pricetype[:deletion_mark] = p['deletion_mark'].to_i == 0 ? false : true
      pricetype[:name] = p['name']
      pricetype.save!
    }
  end


  def connect_1c
    conn = Faraday.new
    conn.basic_auth('admin', '911*')
    conn.response :json, :content_type => /\bjson$/
    conn
  end

  def  clear_img_url
    products = Product.all
    products.each do |prod|
      prod[:image_url] = 'image_url.jpg'
      prod.save
    end

  end

  def post_orders (date1, date2)

    cont ='{"orders":['

    orders = Order.all.where(:date => date1..date2)
    first= true
    orders.each do |order|
      coma = first ? "" : ","
      cont = cont + coma +
          '{"header":' + order.to_json +
          '"clien_unf_id":' + '"'+order.client['unf_id'].to_s + '"' +
          ',"line_items": [' + order.line_items.to_json + "]" + "}"
      first = false
    end

    cont = cont + "]}"
    
    resp = connect_1c.post(get_unf_path("orders"), cont,
                        "Content-Type" => "application/json")
    resp

  end

  def get_unf_path (method)
    unf_base = ExchNode.first();
    path_string = unf_base.ser + "/" + unf_base.cat + "/" + method
    path_string
  end

end

