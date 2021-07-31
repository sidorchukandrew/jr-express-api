class ChangeInvoiceNumberToString < ActiveRecord::Migration[6.1]
  def change
    change_column :invoices, :invoice_number, :string
  end
end
