class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.string :bill_to_city
      t.string :bill_to_company
      t.string :bill_to_street
      t.string :bill_to_state
      t.string :bill_to_zip

      t.string :broker_load_number

      t.string :deliver_to_city
      t.string :deliver_to_company
      t.string :deliver_to_state
      t.string :deliver_to_street
      t.string :deliver_to_zip

      t.integer :invoice_number

      t.decimal :load_pay, precision: 5, scale: 2
      t.decimal :lumper, precision: 5, scale: 2

      t.string :pickup_number

      t.string :pickup_city
      t.string :pickup_company
      t.string :pickup_street
      t.string :pickup_state
      t.string :pickup_zip

      t.timestamps
    end
  end
end
