class Location < ActiveRecord::Base
  include Import

  @sync_type = :locations
  @import_columns = [:identifier, :name, :data_coverage, :min_date, :max_date]

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
