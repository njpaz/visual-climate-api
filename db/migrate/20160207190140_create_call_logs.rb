class CreateCallLogs < ActiveRecord::Migration
  def change
    create_table :call_logs do |t|
      t.string :status
      t.string :message
      t.string :location
      t.string :identifier

      t.timestamps null: false
    end
  end
end
