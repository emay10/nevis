class StatementsController < ApplicationController
  before_action :set_statement, only: [:show, :edit, :update, :destroy, :pdf, :xls]

  # GET /statements
  def index
    #@statements = current_user.statements
    if params[:dash] == 'true'
      @statements = Statement.dash
    else
      @statements = Statement.all
    end
  end

  # GET /statements/1
  def show
    @commissions = Commission.from_statement(@statement)
  end

  # POST /statements
  def create
    user_ids = statement_params[:users].split(',')
    if user_ids.length > 0
      users = User.where(id: user_ids)
      if users and !statement_params[:year].blank? and !statement_params[:month].blank?
        users.each do |u|
          date = Date.new(statement_params[:year].to_i, statement_params[:month].to_i)
          Statement.create(date: date, user: u)
        end
      end
    end
    render status: :ok, nothing: true
  end

  # PATCH/PUT /statements/1
  def update
    if @statement.update(statement_params)
      render status: :ok, nothing: true
    end
  end

  # DELETE /statements/1
  def destroy
    @statement.destroy
    render status: :ok, nothing: true
  end

  def pdf
    require 'prawn'
    require 'securerandom'
    s = @statement
    records = Commission.from_statement(s)
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.pdf"
    Prawn::Document.generate(file, margin: 40) do
      text("Statement for #{s.user.name}", align: :center)
      move_down 20
      cols = [
        'ID',
        'Agent',
        'Carrier',
        'Client',
        'Policy',
        'Statement Month',
        'Earned Month',
        'Commission'
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
        c << record.statement_date.strftime('%m-%d-%Y')
        c << record.earned_date.strftime('%m-%d-%Y')
        c << record.commission
        data << c
        length = c.length
      end
      table(data, position: :center)
      summary = [
        ['Agent', s.user.name],
        ['Statement Month', s.date.strftime('%m-%d-%Y')],
        ['Total Commissions Received', s.total_com],
        ['Total Agent Commissions', s.agent_com],
        ['Commissions by Carrier', s.carrier_com],
      ]
      s.coms_by_carrier.each { |car, com| summary << [car, com]}
      n_sum = []
      summary.each do |row|
        n_row = [{content: row[0], font_style: :bold}, {content: row[1].to_s, align: :center}]
        n_sum << n_row
      end
      move_down 40
      table(n_sum, position: :right, column_widths: [150, 200])
      move_down 20
    end
    send_file file, type: 'application/pdf', x_sendfile: true
  end

  def xls
    require 'spreadsheet'
    require 'securerandom'
    records = Commission.from_statement(@statement)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    bold = Spreadsheet::Format.new weight: :bold
    s = @statement
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
      c << record.statement_date.strftime('%m-%d-%Y')
      c << record.earned_date.strftime('%m-%d-%Y')
      sheet.row(1 + i).replace c
      length += 1
    end
    len = [10, 20, 20, 20, 20, 20]
    len.each_with_index do |col, i|
      sheet.column(i).width = col
    end
    length += 4
    summary = [
      ['Agent', s.user.name],
      ['Statement Month', s.date.strftime('%m-%d-%Y')],
      ['Total Commissions Received', s.total_com],
      ['Total Agent Commissions', s.agent_com],
      ['Commissions by Carrier', s.carrier_com],
    ]
    s.coms_by_carrier.each { |car, com| summary << [car, com]}
    n_sum = []
    summary.each_with_index do |row, i|
      z = [''] * 5
      sheet.row(length + i).replace (z + row)
      sheet.row(length + i).set_format(5, (Spreadsheet::Format.new :weight => :bold))
    end
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.xls"
    File.open(file, "w") {}
    book.write file
    send_file file, type: 'application/vnd.ms-excel', x_sendfile: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statement
      @statement = Statement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statement_params
      params.permit(:users, :date, :year, :status)
    end
end
