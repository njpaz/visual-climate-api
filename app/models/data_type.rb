class DataType < ActiveRecord::Base
  include Import

  belongs_to :data_category
  has_many :weather_data

  has_many :data_set_data_types
  has_many :data_sets, through: :data_set_data_types
  has_many :data_type_locations
  has_many :locations, through: :data_type_locations
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
    missing_categories = DataCategory.where.not(id: pluck(:data_category_id))

    missing_categories.each do |category|
      data = sync.datatypes(params: { 'limit' => 1000, 'datacategoryid' => category.identifier })
      related_categories = data['results'].map { |dr| dr['id'] }

      where(identifier: related_categories).update_all(data_category_id: category.id)
    end
  end

private

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
