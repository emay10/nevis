class PoliciesController < ApplicationController
  before_action :set_policy, only: [:show, :edit, :update, :destroy]

  # GET /policies
  def index
    @policies = Policy.all
  end

  # GET /policies/1
  def show
  end

  # POST /policies
  def create
    @policy = Policy.new(policy_params)
    if @policy.save
      render :show, status: :created, location: @policy
    else
      render json: @policy.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /policies/1
  def update
    if @policy.update(policy_params)
      render :show, status: :ok, location: @policy
    else
      render json: @policy.errors, status: :unprocessable_entity
    end
  end

  # DELETE /policies/1
  def destroy
    @policy.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.require(:policy).permit(:name, :carrier, :kind, :commission)
    end
end
