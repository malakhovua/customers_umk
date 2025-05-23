class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    ensure_an_admin_role
    @users = User.order(:name)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    param = user_params
    param[:role] = param[:role].to_i
    @user = User.new(param)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url,
                                  notice: "Пользователь #{@user.name} был успешно создан." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    params['user']['role'] = params['user']['role'].to_i
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url,
                                  notice: "Пользователь #{@user.name}  был успешно обновлен." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "Пользователь #{@user.name} удален." }
      format.json { head :no_content }
    end
  end

  rescue_from 'User::Error' do |exception|
    redirect_to users_url, notice: exception.message
  end

  private


  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :surname, :unit_id, :client_id, :role,
                                 :access_group_id, :unf_id, :storage_place_id)
  end
end
