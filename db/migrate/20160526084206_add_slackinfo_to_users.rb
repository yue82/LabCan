class AddSlackinfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack_channel, :string
  end
end
