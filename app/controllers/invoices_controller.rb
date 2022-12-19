class InvoicesController < ApplicationController
  require 'combine_pdf'
  require 'net/http'
  require 'tempfile'

  before_action :set_invoice, only: [:show, :update, :destroy]

  # GET /invoices
  def index
    @invoices = Invoice.with_attached_pdf.all.order(created_at: :desc )

    invoices_hash = @invoices.map { |invoice| invoice.to_hash }

    render json: invoices_hash
  end

  # GET /invoices/1
  def show
    render json: @invoice.to_hash
  end

  # POST /invoices
  def create
    @invoice = Invoice.new(invoice_params)

    if @invoice.save
      save_addresses
      generate_pdf
      invoice_with_pdf = @invoice.as_json
      invoice_with_pdf[:pdf_url] = @invoice.pdf.url
      render json: invoice_with_pdf, status: :created
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /invoices/1
  def update
    if @invoice.update(invoice_params)
      render json: @invoice
    else
      render json: @invoice.errors, status: :unprocessable_entity
    end
  end

  # DELETE /invoices/1
  def destroy
    @invoice.destroy
  end

  def email
    @invoice = Invoice.with_attached_pdf.find(params[:invoice_id]) 
    Contact.find_or_create_by(email: params[:recipient])

    @email = Email.new do |e|
      e.subject = params["subject"]
      e.recipient = params["recipient"]
      e.body = params["body"]
      e.invoice_id = @invoice.id
      e.bcc = params["include_bcc"] ? "#{ENV["BCC_ADDRESS"]}, #{ENV["FROM_ADDRESS"]}" : ENV["FROM_ADDRESS"]
    end

    replace_templates
    
    InvoiceMailer.with(email: email_params, invoice: @invoice).invoice_pdf.deliver_now
    
    if @email.save
      render json: @email
    else
      render json: @email.errors 
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.with_attached_pdf.find(params[:id])
    end

    def email_params
      params.permit([:subject, :body, :recipient, :include_bcc])
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.permit([:is_paid, :bill_to_city, :bill_to_company, 
        :bill_to_street, :bill_to_state, :bill_to_zip, :broker_load_number, 
        :deliver_to_city, :deliver_to_company, :deliver_to_state, :deliver_to_street,
        :deliver_to_zip, :invoice_number, :load_pay, :lumper, :pickup_number, :pickup_city,
        :pickup_company, :pickup_street, :pickup_state, :pickup_zip, :reference_number, attachments: []]
      )
    end

    def generate_pdf
      pdf_html = ActionController::Base.new.render_to_string(template: 'invoices/show.html.erb', layout: 'pdf.html', locals: {invoice: @invoice})  
      first_page_of_pdf = WickedPdf.new.pdf_from_string(pdf_html)

      full_pdf = CombinePDF.new
      full_pdf << CombinePDF.parse(first_page_of_pdf)

      @invoice.attachments.each do |attachment|
        full_pdf << CombinePDF.parse(Net::HTTP.get_response(URI.parse(attachment.url)).body)
      end

      @invoice.pdf.attach(io: StringIO.new(full_pdf.to_pdf), filename: "invoice #{@invoice.invoice_number}.pdf", content_type: "application/pdf")

      @invoice.save
    end

    def save_addresses
      bill_to = Address.find_or_create_by(address_type: "bill_to", company: @invoice.bill_to_company) do |address|
        address.address_type = "bill_to"
        address.company = @invoice.bill_to_company
        address.street = @invoice.bill_to_street
        address.city = @invoice.bill_to_city
        address.state = @invoice.bill_to_state
        address.zip = @invoice.bill_to_zip
      end

      pickup = Address.find_or_create_by(address_type: "pickup", company: @invoice.pickup_company) do |address|
        address.address_type = "pickup"
        address.company = @invoice.pickup_company
        address.street = @invoice.pickup_street
        address.city = @invoice.pickup_city
        address.state = @invoice.pickup_state
        address.zip = @invoice.pickup_zip
      end

      deliver_to = Address.find_or_create_by(address_type: "deliver_to", company: @invoice.deliver_to_company) do |address|
        address.address_type = "deliver_to"
        address.company = @invoice.deliver_to_company
        address.street = @invoice.deliver_to_street
        address.city = @invoice.deliver_to_city
        address.state = @invoice.deliver_to_state
        address.zip = @invoice.deliver_to_zip
      end
    end

    def replace_templates
        @email["subject"] = @email["subject"].gsub("{invoice number}", @invoice.invoice_number)
        @email["body"] = @email["body"].gsub("{invoice number}", @invoice.invoice_number)
    end
end
