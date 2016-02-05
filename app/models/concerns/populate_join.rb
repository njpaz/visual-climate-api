module PopulateJoin
  extend ActiveSupport::Concern

  module ClassMethods
    def populate_joins
      sync_param_id = @compare_class.name.downcase + 'id'
      params = get_data(sync: NOAASync.new, sync_param_id: sync_param_id)
      create(params)
    end

    def get_data(sync:, sync_param_id:)
      @compare_class.all.map do |record|
        results = sync.send(@call_class.sync_type, params: {'limit'=> 1000, sync_param_id => record.identifier})
        result_ids = results['results'].map { |rr| rr['id'] }
        result_record_ids = @call_class.where(identifier: result_ids).pluck(:id)

        result_record_ids.map { |result_id| { @compare_class.sync_id => record.id, @call_class.sync_id => result_id } }
      end
    end
  end
end
