class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.boolean :attend, default: false

      t.timestamps null: false
    end
    add_index :attendances, :attend
  end
end
