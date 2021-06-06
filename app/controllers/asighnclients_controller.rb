class AsighnclientsController < ApplicationController

  def get_clients_list
    @clients = Client.all.order(:parent_name, :name)
    @user = User.find(params['user_id'])
  end

  def set_user_for_clients_list
    clients_hash = Hash.new
    params.each do |key, value|
      if key.include? "client"
      clients_hash[key] = value
      end
    end
    asighn_user(clients_hash, params['user_id'])
  end

  def asighn_user(clients_hash, user_id)
       clients_hash.each do |key, value|
        cln = Client.find(value.to_i)
        cln.user_id = user_id
        cln.save
      end
    end
end