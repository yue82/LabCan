class AddCheckTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :check_token, :string
  end
end
