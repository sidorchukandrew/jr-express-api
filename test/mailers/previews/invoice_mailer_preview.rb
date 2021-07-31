# Preview all emails at http://localhost:3000/rails/mailers/invoice_mailer
class InvoiceMailerPreview < ActionMailer::Preview

    def invoice_pdf
        InvoiceMailer.invoice_pdf
    end

end
