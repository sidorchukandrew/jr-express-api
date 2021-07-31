class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :company
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.string :type
      t.timestamps
    end
  end
end
