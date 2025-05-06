# frozen_string_literal: true

require 'json'

module V1
  class InventoriesController < ActionController::API
    include ActionController::HttpAuthentication::Basic::ControllerMethods
    http_basic_authenticate_with name: 'username_api', password: 'ScGAyJqi8W0TU3'

    def create
      msg = ''
      params = JSON.parse request.body.read
      params.each do |param|
        inventory_params = param['Inventory']
        inventory_line_items_params = param['InventoryLineItems']
        @inventory = if Inventory.where(unf_number: inventory_params['unf_number']).present?
                       Inventory.find_by(unf_number: inventory_params['unf_number'])
                     else
                       Inventory.new
                     end
        @inventory.date = inventory_params['date']
        @inventory.unf_number = inventory_params['unf_number']
        @inventory.inv_type = inventory_params['inv_type']
        @inventory.status = inventory_params['status']
        @inventory.desc = inventory_params['descr']
        @inventory.user = User.find_by(unf_id: inventory_params['user_unf_id'])
        storage_place = if StoragePlace.where(unf_id: inventory_params['storage_place_unf_id']).present?
                          StoragePlace.find_by(unf_id: inventory_params['storage_place_unf_id'])
                        else
                          StoragePlace.new
                        end
        storage_place.params_json_to_object(inventory_params)
        storage_place.save
        @inventory.storage_place = storage_place
        @inventory.created_at = Time.now
        @inventory.inventory_line_items.destroy_all
        @inventory.sum = 0.0
        # line_items
        inventory_line_items_params.each { |dt|
          prod = if Product.where(unf_id: dt['unf_id']).present?
                   Product.find_by(unf_id: dt['unf_id'])
                 else
                   Product.new
                 end
          prod.params_json_to_object(dt)
          prod.save
          # units
          data_units = dt['units']
          data_units.each { |dt_unit|
            unit = if UnitProduct.where(unf_id: dt_unit['unf_id']).present?
                     UnitProduct.find_by(unf_id: dt_unit['unf_id'])
                   else
                     UnitProduct.new
                   end
            unit.params_json_to_object(prod, dt_unit)
            unit.save!
          } # unit product
          unit_product = UnitProduct.find_by(unf_id: dt['unit_unf_id'])
          @inventory.inventory_line_items.build(product: prod, comment: dt['comment'], price: dt['price'],
                                                row_number: dt['row_number'],
                                                unit_product: unit_product, sum: 0.0)
        } # line items
        @inventory.save!
        render json: msg
      end
    end

    def show
      @inventory = Inventory.where('unf_number = :id and date >= :date and status = 1', { :id=> params['id'], :date=> params['date'].to_date })
      if @inventory.present?
        @inventory_line_items = InventoryLineItem.all.where(inventory_id: @inventory[0].id)
        line_items_data = []
        @inventory_line_items.each do |inventory_line_item|
          line_items_data << { qty: inventory_line_item.qty, comment: inventory_line_item.comment,
                               product: inventory_line_item.product.nil? ? inventory_line_item.rko : inventory_line_item.product.rko,
                               product_name: inventory_line_item.product_name, price: inventory_line_item.price}
        end
        data = { main_comment: @inventory[0].desc, line_items: line_items_data }
        render json: data
      else
        render json: '[]'
      end
    end
  end

end

