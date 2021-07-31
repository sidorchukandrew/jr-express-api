class InvoiceNumbersController < ApplicationController
    def next_number
        @invoice = Invoice.most_recent_this_year
        next_invoice_number = 0


        if @invoice.present?
            invoice_number = @invoice.invoice_number[2..-1]
            next_number = Integer(invoice_number) + 1

            next_invoice_number = year.to_s + next_number.to_s.rjust(2, "0")
        else
            next_invoice_number = year.to_s + "01"
           
        end

        render json: {number: next_invoice_number}
    end

    private 
    def year
        Time.current.year % 100
    end

end
