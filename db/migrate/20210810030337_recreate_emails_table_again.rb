class RecreateEmailsTableAgain < ActiveRecord::Migration[6.1]
  def change
    drop_table :emails

    create_table :emails do |t|
      t.string :recipient
      t.string :subject
      t.string :body
      t.string :bcc
      t.belongs_to :invoice
      t.timestamps
    end
  end
end
