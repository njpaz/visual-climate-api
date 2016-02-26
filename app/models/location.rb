class Location < ActiveRecord::Base
  include Import

  belongs_to :location_category
  has_many :data_category_locations
  has_many :data_categories, through: :data_category_locations
  has_many :data_set_locations
  has_many :data_sets, through: :data_set_locations
  has_many :location_stations
  has_many :stations, through: :location_stations

  @sync_type = :locations
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
    missing_categories = LocationCategory.where.not(id: pluck(:location_category_id))

    begin
      missing_categories.each do |category|
        data = sync.locations(params: { 'limit' => 1000, 'locationcategoryid' => category.identifier })
        related_locations = data['results'].map { |dr| dr['id'] }

        count = data['metadata']['resultset']['count']
        offset = 1001

        while offset <= count
          data = sync.locations(params: { 'limit' => 1000, 'locationcategoryid' => category.identifier, 'offset' => offset })
          related_locations += data['results'].map { |dr| dr['id'] }
          offset += 1000
        end

        where(identifier: related_locations).update_all(location_category_id: category.id)
      end
    rescue
      CallLog.create(status: data['status'], message: data['message'], location: self.name, identifier: category.identifier, location_method: 'populate_belongs_to')
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
          Date.strptime(result['maxdate'], '%Y-%m-%d'),
        ]
      end
    end

    imports
  end
end
