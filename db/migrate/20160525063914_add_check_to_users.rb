class AddCheckToUsers < ActiveRecord::Migration
  def change
    add_column :users, :check_digest, :string
  end
end
