require 'faraday'
require 'faraday_middleware'
require 'json'
require 'base64'

class Unf

  def get_products

    res = connect_1c.get('http://relay3.kumk.com.ua:8088/NMFC_dev/hs/site-api/products')

    data = JSON.parse res.body

    data.each { |p|

      if Product.where(:id => p['id'].to_i).present?
        prod = Product.find_by(id: p['id'])
      else
        prod = Product.new
      end

      prod[:id] = p['id']
      prod[:title] = p['title']
      prod[:description] = 'description'
      prod[:is_folder] = p['is_folder'].to_i == 0 ? false : true
      prod[:parent_id] = p['parent_id'].to_i
      prod[:price] = 0.01
      prod[:created_at] = Time.now

      if p['binary_file'] == ''
        prod.image_url = 'stop.png'
      else
        base64_image = p['binary_file']
        # decode64
        img_from_base64 = Base64.decode64(base64_image)
        # file type
        filetype = p['file_extension']
        # name the file
        filename = './app/assets/images/' + p['id'].to_s

        # write file
        file = filename << '.' << filetype
        File.open(file, 'wb') do |f|
          f.write(img_from_base64)
        end
        prod.image_url = p['id'].to_s + '.' + filetype
      end
      #end file
      if prod[:is_folder] == true
        prod.image_url = 'folder_01.jpg'
      end

      prod.save
    }
  end

  def get_packs

    res = connect_1c.get('http://relay3.kumk.com.ua:8088/NMFC_dev/hs/site-api/packs')

    data = JSON.parse res.body

    data.each { |p|

      if Pack.where(:id => p['id']).present?
        pack = Pack.find_by(id: p['id'].to_i)
      else
        pack = Pack.new
      end

      pack[:id] = p['id'].to_i
      pack[:name] = p['name']
      pack[:description] = p['description']
      pack[:product_id] = p['product_id'].to_i
      pack[:created_at] = Time.now
      pack.save
    }
  end

  def get_prices

    res = connect_1c.get('http://relay3.kumk.com.ua:8088/NMFC_dev/hs/site-api/price')

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

  def get_price_types

    res = connect_1c.get('http://relay3.kumk.com.ua:8088/NMFC_dev/hs/site-api/pricetype')

    data = JSON.parse res.body

    data.each { |p|

      if Pricetype.where(:id => p['id']).present?
        pricetype = Pricetype.find_by(id: p['id'])
      else
        pricetype = Pricetype.new
      end

      pricetype[:id] = p['id']
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

end

