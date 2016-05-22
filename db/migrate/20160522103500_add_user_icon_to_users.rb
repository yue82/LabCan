class AddUserIconToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_icon, :string
  end
end
