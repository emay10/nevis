class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :update, :destroy]

  # GET /clients
  def index
    @clients = Client
    unless params[:q].blank?
      @clients = @clients.search(params[:q])
    end
    ids = current_user.co_ids
    @clients = @clients.select {|c| ids.include? c.user_id }
  end

  # GET /clients/1
  def show
  end

  # GET /clients/pdf
  def pdf
    require 'prawn'
    require 'securerandom'
    records = current_user.agency_data(:clients)
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.pdf"
    Prawn::Document.generate(file, margin: 40) do
      text("Clients", align: :center)
      move_down 20
      cols = [
        'ID',
        'Name',
        'Agent',
        'Carrier',
        'Policy',
        'Quantity',
        'Effective Date',
        'Status',
      ]
      data = [cols]
      length = 0
      move_down 20
      font_size 10
      records.each do |record|
        c = []
        c << record.id
        c << record.name
        if record.user
          c << record.user.name
        else
          c << ''
        end
        if record.policy
          c << record.policy.carrier
          c << record.policy.kind
        else
          c << ''
        end
        c << record.quantity
        c << record.effective_date
        c << record.status
        data << c
        length = c.length
      end
      table(data, position: :center)
      move_down 20
    end
    render json: {url: "/tmp/files/#{code}.pdf"}
  end

  def xls
    require 'spreadsheet'
    require 'securerandom'
    records = current_user.agency_data(:clients)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    bold = Spreadsheet::Format.new weight: :bold

    #sheet.row(0).push "Clients"
    cols = [
      'ID',
      'Name',
      'Agent',
      'Carrier',
      'Policy',
      'Quantity',
      'Effective Date',
      'Status',
    ]
    sheet.row(0).replace cols
    sheet.row(0).default_format = bold
    length = 0
    records.each_with_index do |record, i|
      c = []
      c << record.id
      c << record.name
      if record.user
        c << record.user.name
      else
        c << ''
      end
      if record.policy
        c << record.policy.carrier
        c << record.policy.kind
      else
        c << ''
      end
      c << record.quantity
      c << record.effective_date
      c << record.status
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
    render json: {url: "/tmp/files/#{code}.xls"}
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
      @client = Client.find_by(id: params[:id], user_id: current_user.co_ids)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def client_params
      params.require(:client).permit(:name, :number, :status, :quantity, :policy_id, :user_id)
    end
end
