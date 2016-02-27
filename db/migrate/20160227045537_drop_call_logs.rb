class DropCallLogs < ActiveRecord::Migration
  def up
    drop_table :call_logs
  end

  def down
    create_table :call_logs do |t|
      t.string :status
      t.string :message
      t.string :location
      t.string :identifier

      t.timestamps null: false
    end
  end
end
