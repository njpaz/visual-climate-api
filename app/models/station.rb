class Station < ActiveRecord::Base
  include Import
  include BelongsToImport

  has_many :weather_data
  has_many :data_category_stations
  has_many :data_categories, through: :data_category_stations
  has_many :data_set_stations
  has_many :data_sets, through: :data_set_stations
  has_many :data_type_stations
  has_many :data_types, through: :data_type_stations
  belongs_to :location

  @sync_type = :stations
  @import_columns = [:identifier, :name, :elevation, :latitude, :longitude, :elevation_unit, :min_date, :max_date]
  @belongs_to_class = Location

  def self.sync_type
    @sync_type
  end

  def self.sync_id
    key_name = name.underscore + '_id'
    key_name.to_sym
  end

  def titlecase_name
    split_name = name.split(', ')
    split_name.first.titleize + ', ' + split_name.last
  end

private

  def self.format_imports(data_results, existing_sets)
    imports = []

    data_results.each do |result|
      unless existing_sets.include?(result['id'])
        imports << [
          result['id'],
          result['name'],
          result['elevation'],
          result['latitude'],
          result['longitude'],
          result['elevationUnit'],
          Date.strptime(result['mindate'], '%Y-%m-%d'),
          Date.strptime(result['maxdate'], '%Y-%m-%d')
        ]
      end
    end

    imports
  end
end
