class InvoiceMailer < ApplicationMailer

    def invoice_pdf
        @invoice =  params[:invoice]
        @email = params[:email]

        replace_templates

        attachments['invoice.pdf'] = { mime_type: 'application/pdf', content: @invoice.pdf.blob.download }
        mail(to: @email["recipient"], subject: @email["subject"])
    end

    private
    def replace_templates
        @email["subject"] = @email["subject"].gsub("{invoice number}", @invoice.invoice_number)
        @email["body"] = @email["body"].gsub("{invoice number}", @invoice.invoice_number)
    end

end
