class LocationCategory < ActiveRecord::Base
  include Import

  has_many :data_set_location_categories
  has_many :data_sets, through: :data_set_location_categories
  has_many :location_category_locations
  has_many :locations, through: :location_category_locations

  @sync_type = :locationcategories
  @import_columns = [:identifier, :name]

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
        imports << [result['id'], result['name']]
      end
    end

    imports
  end
end
