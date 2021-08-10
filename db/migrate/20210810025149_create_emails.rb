class CreateEmails < ActiveRecord::Migration[6.1]
  def change
    create_table :emails do |t|
      t.string :recipient
      t.string :subject
      t.string :body
      t.string :bcc
      t.references :invoices
      t.timestamps
    end
  end
end
