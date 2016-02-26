class CallLog < ActiveRecord::Base
  def self.process
    CallLog.find_each do |log|
      log.location.constantize.send(log.location_method)
      log.destroy
    end
  end
end
