class DataSet < ActiveRecord::Base
  include Import

  has_many :weather_data
  has_many :data_category_data_sets
  has_many :data_categories, through: :data_category_data_sets
  has_many :data_set_data_types
  has_many :data_types, through: :data_set_data_types
  has_many :data_set_location_categories
  has_many :location_categories, through: :data_set_location_categories
  has_many :data_set_locations
  has_many :locations, through: :data_set_locations
  has_many :data_set_stations
  has_many :stations, through: :data_set_stations

  @sync_type = :datasets
  @import_columns = [:identifier, :name, :data_coverage, :min_date, :max_date]

  def self.sync_type
    @sync_type
  end

  def self.sync_id
    key_name = name.underscore + '_id'
    key_name.to_sym
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
