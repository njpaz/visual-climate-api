module PopulateJoin
  extend ActiveSupport::Concern

  module ClassMethods
    def populate_joins
      sync_param_id = @compare_class.name.downcase + 'id'
      present_ids = self.pluck(@compare_class.sync_id)
      missing_records = @compare_class.where.not(id: present_ids)
      params = iterate_through_records(sync: NOAASync.new, sync_param_id: sync_param_id, missing_records: missing_records)
      import import_columns, params
    end

    def iterate_through_records(sync:, sync_param_id:, missing_records:)
      results_arr = []

      missing_records.each do |record|
        begin
          data = sync.send(@call_class.sync_type, params: { 'limit' => 1000, sync_param_id => record.identifier })
          results_arr += get_results(sync: sync, data: data, sync_param_id: sync_param_id, record: record)
        rescue
          if data['status'] == '429' # reached API limit for the day
            RetryPopulateJob.set(wait_until: Date.tomorrow.midnight).perform_later self.name, 'populate_joins'
          end
          next
        end
      end

      results_arr
    end

  private

    def import_columns
      [@compare_class.sync_id, @call_class.sync_id]
    end

    def get_results(sync:, data:, sync_param_id:, record:)
      results = loop_through_data(record: record, sync_param_id: sync_param_id, sync: sync, data: data, count: data['metadata']['resultset']['count'])

      result_ids = results.map { |rr| rr['id'] }
      result_record_ids = @call_class.where(identifier: result_ids).pluck(:id)
      result_record_ids.map { |result_id| [record.id, result_id] }
    end

    def loop_through_data(record:, sync_param_id:, sync:, data:, count:, offset: 1001)
      results = data['results']

      while offset <= count
        data = sync.send(@call_class.sync_type, params: { 'limit' => 1000, 'offset' => offset, sync_param_id => record.identifier })
        results += data['results']
        offset += 1000
      end

      results
    end

  end
end
