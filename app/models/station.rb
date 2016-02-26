class Station < ActiveRecord::Base
  include Import

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


  def self.sync_type
    @sync_type
  end

  def self.sync_id
    key_name = name.underscore + '_id'
    key_name.to_sym
  end

  def self.populate_belongs_to
    sync = NOAASync.new
    missing_locations = Location.where.not(id: pluck(:location_id))

    begin
      missing_locations.each do |location|
        data = sync.stations(params: { 'limit' => 1000, 'locationid' => location.identifier })
        related_locations = data['results'].map { |dr| dr['id'] }

        count = data['metadata']['resultset']['count']
        offset = 1001

        while offset <= count
          data = sync.stations(params: { 'limit' => 1000, 'locationid' => location.identifier, 'offset' => offset })
          related_locations += data['results'].map { |dr| dr['id'] }
          offset += 1000
        end

        where(identifier: related_locations).update_all(location_id: location.id)
      end
    rescue
      CallLog.create(status: data['status'], message: data['message'], location: self.name, identifier: location.identifier, location_method: 'populate_belongs_to')
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
