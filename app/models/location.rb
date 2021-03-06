class Location < ActiveRecord::Base
  include Import
  include BelongsToImport

  belongs_to :location_category
  has_many :data_category_locations
  has_many :data_categories, through: :data_category_locations
  has_many :data_set_locations
  has_many :data_sets, through: :data_set_locations
  has_many :stations

  @sync_type = :locations
  @import_columns = [:identifier, :name, :data_coverage, :min_date, :max_date]
  @belongs_to_class = LocationCategory

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
          Date.strptime(result['maxdate'], '%Y-%m-%d'),
        ]
      end
    end

    imports
  end
end
