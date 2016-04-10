class CommissionsController < ApplicationController
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  # GET /commissions
  def index
    @commissions = Commission.all
  end

  # GET /commissions/1
  def show
  end

  # POST /commissions
  def create
    @commission = Commission.new(commission_params)
    if @commission.save
      render :show, status: :created, location: @commission
    else
      render json: @commission.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /commissions/1
  def update
    if @commission.update(commission_params)
      render :show, status: :ok, location: @commission
    else
      render json: @commission.errors, status: :unprocessable_entity
    end
  end

  # DELETE /commissions/1
  # DELETE /commissions/1.json
  def destroy
    @commission.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commission
      @commission = Commission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commission_params
      params.require(:commission).permit(:client_id, :user_id, :policy_id, :amount)
    end
end
