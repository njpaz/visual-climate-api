class AddLocationMethodToCallLogs < ActiveRecord::Migration
  def change
    add_column :call_logs, :location_method, :string
  end
end
