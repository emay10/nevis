class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]

  # GET /clients
  def index
    @clients = Client.all
  end

  # GET /clients/1
  def show
  end

  # GET /clients/pdf
  def pdf
    require 'prawn'
    require 'securerandom'
    records = Client.all
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.pdf"
    Prawn::Document.generate(file, margin: 40) do
      text("Clients", align: :center)
      move_down 20
      cols = [
        'ID',
        'Name',
        'Quantity',
        'Status',
        'Policy',
      ]
      data = [cols]
      length = 0
      move_down 20
      font_size 10
      records.each do |record|
        c = []
        c << record.id
        c << record.name
        c << record.quantity
        c << record.status
        if record.policy
          c << record.policy.name 
        else
          c << ''
        end
        data << c
        length = c.length
      end
      table(data, position: :center)
      move_down 20
    end
    send_file file, type: 'application/pdf', x_sendfile: true
  end

  def xls
    require 'spreadsheet'
    require 'securerandom'
    records = Client.all
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    bold = Spreadsheet::Format.new weight: :bold

    #sheet.row(0).push "Clients"
    cols = [
      'ID',
      'Name',
      'Quantity',
      'Status',
      'Policy',
    ]
    sheet.row(0).replace cols
    sheet.row(0).default_format = bold
    length = 0
    records.each_with_index do |record, i|
      c = []
      c << record.id
      c << record.name
      c << record.quantity
      c << record.status
      if record.policy
        c << record.policy.name 
      else
        c << ''
      end
      sheet.row(1 + i).replace c
    end
    len = [10, 20, 20, 20, 20, 20]
    len.each_with_index do |col, i|
      sheet.column(i).width = col
    end
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.xls"
    File.open(file, "w") {}
    book.write file
    send_file file, type: 'application/vnd.ms-excel', x_sendfile: true
  end

  # POST /clients
  def create
    @client = Client.new(client_params)
    if @client.save
      render :show, status: :created, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clients/1
  def update
    if @client.update(client_params)
      render :show, status: :ok, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  def destroy
    @client.destroy
    render status: :ok, nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :number, :status, :quantity, :policy_id, :user_id)
    end
end
