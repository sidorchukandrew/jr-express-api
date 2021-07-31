class Invoice < ApplicationRecord
    has_one_attached :pdf
    has_many_attached :attachments

    scope :most_recent_this_year, -> {where("invoice_number LIKE ?", "#{Time.current.year % 100}%").order(invoice_number: :desc).first}

    def to_hash
        invoice_hash = self.as_json
        invoice_hash[:pdf_url] = self.pdf.url if self.pdf.attached?
        invoice_hash
    end

    private
    def year
        
    end
end
