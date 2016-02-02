class Station < ActiveRecord::Base
  include Import

  @sync_type = :stations
  @import_columns = [:identifier, :name, :elevation, :latitude, :longitude, :elevation_unit, :min_date, :max_date]

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
