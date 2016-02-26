module BelongsToImport
  extend ActiveSupport::Concern

  module ClassMethods
    def populate_belongs_to
      sync = NOAASync.new
      belongs_to_id = @belongs_to_class.sync_id
      missing_records = @belongs_to_class.where.not(id: pluck(belongs_to_id))
      belongs_to_sync_id = @belongs_to_class.sync_id.to_s.gsub('_', '')

      missing_records.each do |record|
        begin
          params = { 'limit' => 1000, belongs_to_sync_id => record.identifier }
          data = sync.send(sync_type, params: params)
          related_records = get_related_data(data, params)

          where(identifier: related_records).update_all(belongs_to_id => record.id)
        rescue
          CallLog.find_or_create_by(status: data['status'], message: data['message'], location: self.name, location_method: 'populate_belongs_to')
          next
        end
      end
    end

  private

    def get_related_data(data, params)
      related_records = data['results'].map { |dr| dr['id'] }

      count = data['metadata']['resultset']['count']
      offset = 1001

      while offset <= count
        params['offset'] = offset
        data = sync.send(sync_type, params: params)
        related_records += data['results'].map { |dr| dr['id'] }
        offset += 1000
      end

      related_records
    end
  end
end
