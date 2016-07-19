class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authenticate_user, only: :create

  # GET /users
  def index
    @users = current_user.coworkers
  end

  def current
    @user = current_user
  end

  # GET /users/1
  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    @user.attributes = user_params
    if @user.save(validate: false)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :commission, :password, :password_confirmation, :agency_id)
    end
end
