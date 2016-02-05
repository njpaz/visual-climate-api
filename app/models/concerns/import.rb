module Import
  extend ActiveSupport::Concern

  module ClassMethods
    def populate
      import @import_columns, get_data
    end

    def get_data
      sync = NOAASync.new
      metadata = sync.send(@sync_type)
      count = metadata['metadata']['resultset']['count']

      gather_all_data(sync, count, pluck(:identifier))
    end

  private

    def gather_all_data(sync, count, existing_sets, limit: 1000, offset: 2)
      imported_data = call_import(limit: 1, sync: sync, existing_sets: existing_sets)

      while offset <= count
        imported_data += call_import(limit: limit, offset: offset, sync: sync, existing_sets: existing_sets)
        offset +=  limit
      end

      imported_data
    end

    def call_import(limit:, offset: 0, sync:, existing_sets:)
      data = sync.send(@sync_type, params: { 'limit' => limit, 'offset' => offset })
      format_imports(data['results'], existing_sets)
    end
  end
end
