class StoragePlacesController < ApplicationController
  before_action :set_storage_place, only: %i[ show edit update destroy ]

  # GET /storage_places or /storage_places.json
  def index
    @storage_places = StoragePlace.all
  end

  # GET /storage_places/1 or /storage_places/1.json
  def show
  end

  # GET /storage_places/new
  def new
    @storage_place = StoragePlace.new
  end

  # GET /storage_places/1/edit
  def edit
  end

  # POST /storage_places or /storage_places.json
  def create
    @storage_place = StoragePlace.new(storage_place_params)

    respond_to do |format|
      if @storage_place.save
        format.html { redirect_to @storage_place, notice: "Storage place was successfully created." }
        format.json { render :show, status: :created, location: @storage_place }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @storage_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /storage_places/1 or /storage_places/1.json
  def update
    respond_to do |format|
      if @storage_place.update(storage_place_params)
        format.html { redirect_to @storage_place, notice: "Storage place was successfully updated." }
        format.json { render :show, status: :ok, location: @storage_place }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @storage_place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /storage_places/1 or /storage_places/1.json
  def destroy
    @storage_place.destroy
    respond_to do |format|
      format.html { redirect_to storage_places_url, notice: "Storage place was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_storage_place
      @storage_place = StoragePlace.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def storage_place_params
      params.require(:storage_place).permit(:title, :unf_id)
    end
end
