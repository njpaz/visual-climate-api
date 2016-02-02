class DataCategory < ActiveRecord::Base
  include Import

  @sync_type = :datacategories
  @import_columns = [:identifier, :name]

private

  def self.format_imports(data_results, existing_sets)
    imports = []

    data_results.each do |result|
      unless existing_sets.include?(result['id'])
        imports << [result['id'], result['name']]
      end
    end

    imports
  end
end
