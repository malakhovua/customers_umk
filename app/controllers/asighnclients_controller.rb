class AsighnclientsController < ApplicationController

  def index
    @asighnclients = Asighnclient.all.order(:user_id, :client_id).page params[:page]
  end

  def destroy
    @asighnclient = Asighnclient.find(params[:id])
    @asighnclient.destroy
    respond_to do |format|
      format.html { redirect_to asighnclients_url}
      format.json { head :no_content }
    end
  end

  def get_clients_list
    if params['client_id']
      @clients = Client.where(:parent_id => params['client_id'], :is_folder => false).order(:parent_name, :name)
      @client_id = params['client_id']
    else
      @clients = Client.where(:is_folder => false).order(:parent_name, :name)
    end
    @user = User.find(params['user_id'])
  end

  def set_user_for_clients_list
    if params["commit"] == "Применить отбор"
      respond_to do |format|
        format.html { redirect_to get_clients_list_path(user_id: params['user_id'], client_id: params['client_id'])}
      end
      return
      end

    clients_hash = Hash.new
    params.each do |key, value|
      if key.include? "client"
        clients_hash[key] = value
      end
    end
    asighn_user(clients_hash, params['user_id'])

    respond_to do |format|
        format.html { redirect_to asighnclients_url}
      end

  end

  def asighn_user(clients_hash, user_id)
    clients_hash.each do |key, value|
      if Asighnclient.find_by(user_id: user_id, client_id: value).nil?
        usr = User.find(user_id)
        cl = Client.find(value)
        usr.asighnclients.create(client: cl)
        usr.save
      end
    end
  end
end