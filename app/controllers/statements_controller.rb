class StatementsController < ApplicationController
  before_action :set_statement, only: [:show, :edit, :update, :destroy]

  # GET /statements
  def index
    @statements = Statement.all
  end

  # GET /statements/1
  def show
  end

  # POST /statements
  def create
    @statement = Statement.new(statement_params)

    if @statement.save
      render :show, status: :created, location: @statement
    else
      render json: @statement.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /statements/1
  def update
    if @statement.update(statement_params)
      render :show, status: :ok, location: @statement
    else
      render json: @statement.errors, status: :unprocessable_entity
    end
  end

  # DELETE /statements/1
  def destroy
    @statement.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statement
      @statement = Statement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statement_params
      params.require(:statement).permit(:user_id, :date)
    end
end
