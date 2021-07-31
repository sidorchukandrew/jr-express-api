class AddReferenceNumberToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :reference_number, :string
  end
end
