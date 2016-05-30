class AddTempIconToUsers < ActiveRecord::Migration
  def change
    add_column :users, :temp_icon, :string
  end
end
