class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy]

  # GET /agencies
  def index
    @agencies = Agency.all
  end

  # GET /agencies/1
  def show
  end

  # POST /agencies
  def create
    @agency = Agency.new(agency_params)

    if @agency.save
      render :show, status: :created, location: @agency
    else
      render json: @agency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /agencies/1
  def update
    if @agency.update(agency_params)
      render :show, status: :ok, location: @agency
    else
      render json: @agency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /agencies/1
  def destroy
    @agency.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agency
      @agency = Agency.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def agency_params
      params.require(:agency).permit(:name)
    end
end
