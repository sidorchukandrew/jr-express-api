class AddIsPaidColumnToInvoices < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :is_paid, :boolean, default: false
  end
end
