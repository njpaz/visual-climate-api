class DataType < ActiveRecord::Base
  include Import

  belongs_to :data_category
  has_many :locations
  has_many :weather_data

  has_many :data_set_data_types
  has_many :data_sets, through: :data_set_data_types
  has_many :data_type_stations
  has_many :stations, through: :data_type_stations

  @sync_type = :datatypes
  @import_columns = [:identifier, :name, :data_coverage, :min_date, :max_date]

  def self.sync_type
    @sync_type
  end

  def self.sync_id
    key_name = name.underscore + '_id'
    key_name.to_sym
  end

  def self.populate_belongs_to
    sync = NOAASync.new
    populate_individual_belongs_to(sync: sync, related_class: DataCategory, field: :data_category_id)
    populate_individual_belongs_to(sync: sync, related_class: Location, field: :location_id)
  end

private

  def self.populate_individual_belongs_to(sync:, related_class:, field:)
    missing_records = related_class.where.not(id: pluck(field))
    sync_param = related_class.sync_id.to_s.gsub('_', '')

    missing_records.each do |record|
      data = sync.datatypes(params: { 'limit' => 1000, sync_param => record.identifier})
      begin
        related_records = data['results'].map { |dr| dr['id'] }

        where(identifier: related_records).update_all({ related_class.sync_id => record.id })
      rescue
        if data['status'] == '429' # reached API limit for the day
          RetryPopulateJob.set(wait_until: Date.tomorrow.noon).perform_later self.name, 'populate_belongs_to'
        end
        break
      end
    end
  end

  def self.format_imports(data_results, existing_sets)
    imports = []

    data_results.each do |result|
      unless existing_sets.include?(result['id'])
        imports << [
          result['id'],
          result['name'],
          result['datacoverage'],
          Date.strptime(result['mindate'], '%Y-%m-%d'),
          Date.strptime(result['maxdate'], '%Y-%m-%d')
        ]
      end
    end

    imports
  end
end
