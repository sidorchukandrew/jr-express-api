class CreateEmailSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :email_settings do |t|
      t.string :default_subject
      t.string :default_body
      t.timestamps
    end
  end
end
