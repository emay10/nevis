class CommissionsController < ApplicationController
  before_action :set_commission, only: [:show, :edit, :update, :destroy]

  # GET /commissions
  def index
    @commissions = Commission.all
  end

  # GET /commissions/1
  def show
  end

  def import
    require 'csv'
    require 'securerandom'
    file = params[:file]['0']
    if file and file.content_type == 'text/csv'
      CSV.foreach(file.path, headers: true) do |row|
        u = User.where(name: row['Agent']).first_or_initialize
        if u.email.blank?
          u.email = "#{SecureRandom.hex}@example.com"
        end
        u.save(validate: false)
        type = row['Policy Type']
        kind = (type and type === 'Medicare Supp') ? 'medicare' : type.downcase
        p = Policy.where(carrier: row['Carrier'], kind: kind).first_or_create
        c = Client.where(name: row['Client'], policy: p, user: u).first_or_create
        com = Commission.new(client: c)
        com.statement_date = Date.parse(row['Statement Date'])
        com.earned_date = Date.parse(row['Earned Month'])
        unless row['Commission Basis'].blank?
          if p.kind === 'medicare'
            val = row['Commission Basis'].gsub('$', '')
            #com.commission = val
          else
            #com.commission = p.commission.to_i * row['Commission Basis'].to_i
          end
        end
        com.save
      end
    end
    render status: :ok, nothing: true
  end

  def pdf
    require 'prawn'
    require 'securerandom'
    records = Commission.all
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.pdf"
    Prawn::Document.generate(file, margin: 40) do
      text("Commissions", align: :center)
      move_down 20
      cols = [
        'ID',
        'Agent',
        'Carrier',
        'Client',
        'Policy',
        'Statement Month',
        'Earned Month',
      ]
      data = [cols]
      length = 0
      move_down 20
      font_size 10
      records.each do |record|
        c = []
        c << record.id
        if record.client.user
          c << record.client.user.name 
        else
          c << ''
        end
        if record.client.policy
          c << record.client.policy.carrier
        else
          c << ''
        end
        if record.client
          c << record.client.name 
        else
          c << ''
        end
        if record.client.policy
          c << record.client.policy.kind
        else
          c << ''
        end
        c << record.statement_date
        c << record.earned_date
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
    records = Commission.all
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    bold = Spreadsheet::Format.new weight: :bold

    cols = [
      'ID',
      'Agent',
      'Carrier',
      'Client',
      'Policy',
      'Statement Month',
      'Earned Month',
    ]
    sheet.row(0).replace cols
    sheet.row(0).default_format = bold
    length = 0
    records.each_with_index do |record, i|
      c = []
      c << record.id
      if record.client.user
        c << record.client.user.name 
      else
        c << ''
      end
      if record.client.policy
        c << record.client.policy.carrier
      else
        c << ''
      end
      if record.client
        c << record.client.name 
      else
        c << ''
      end
      if record.client.policy
        c << record.client.policy.kind
      else
        c << ''
      end
      c << record.statement_date
      c << record.earned_date
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
      params.require(:commission).permit(:statement_date, :earned_date, :client_id)
    end
end
