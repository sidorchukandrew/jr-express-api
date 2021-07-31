class ModifyTypeColumnOnAddresses < ActiveRecord::Migration[6.1]
  def change
    rename_column :addresses, :type, :address_type
  end
end
