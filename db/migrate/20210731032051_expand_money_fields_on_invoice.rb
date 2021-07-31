class ExpandMoneyFieldsOnInvoice < ActiveRecord::Migration[6.1]
  def change
    change_column :invoices, :load_pay, :decimal, precision: 10, scale: 2
    change_column :invoices, :lumper, :decimal, precision: 10, scale: 2
  end
end
