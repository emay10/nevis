class StatementsController < ApplicationController
  before_action :set_statement, only: [:show, :edit, :update, :destroy, :pdf, :xls]

  # GET /statements
  def index
    @statements = current_user.agency_data(:statements)
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
    render json: {url: "/tmp/files/#{code}.pdf"}
  end

  def xls
    require 'spreadsheet'
    require 'securerandom'
    records = Commission.from_statement(@statement)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet
    bold = Spreadsheet::Format.new weight: :bold
    s = @statement
    length = 0
    summary = [
      ['Agent', s.user.name],
      ['Statement Month', s.date.strftime('%B %Y')],
      ['', ''],
      ['', ''],
      ['Total Agent Commissions', "$#{s.agent_com}"],
      ['', ''],
      ['Commissions by Carrier', "$#{s.carrier_com}"],
    ]
    z = s.coms_by_carrier.each { |car, com| summary << [car, com]}
    policies = records
      .map(&:client)
      .map(&:policy)
      .map {|x| [x.id, x.carrier] }
    policies.uniq! {|x| x.first }
    n_sum = []
    #sheet.row(1).format(1).border = :thin
    t = 0
    summary.each_with_index do |row, i|
      sheet.row(length + i).replace (row)
      sheet.row(length + i).set_format(0, (Spreadsheet::Format.new :weight => :bold))
      t += 1
    end
    length += (t+2)
    cols = [
      'ID',
      'Client',
      'Policy',
      'Statement Month',
      'Earned Month',
    ]
    length += 1
    policies.each do |policy|
      sheet.row(length).set_format(0, bold)
      sheet.row(length).replace [policy.second, "Total: #{z[policy.second]}"]
      length += 1
      sheet.row(length).replace cols
      sheet.row(length).default_format = bold
      length += 1
      t = 0
      cls = Client.where(policy_id: policy.first).map(&:id)
      records.where(client_id: cls).each_with_index do |record, i|
        c = []
        c << record.id
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
        sheet.row(length + i).replace c
        t += 1
      end
      length += (t+2)
    end
    len = [10, 20, 20, 20, 20, 20]
    len.each_with_index do |col, i|
      sheet.column(i).width = col
    end
    length += 4
    
    code = SecureRandom.hex 
    file = "#{Rails.root}/public/tmp/files/#{code}.xls"
    File.open(file, "w") {}
    book.write file
    render json: {url: "/tmp/files/#{code}.xls"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_statement
      @statement = Statement.find_by(id: params[:id], user_id: current_user.co_ids)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def statement_params
      params.permit(:users, :date, :year, :month, :status)
    end
end
