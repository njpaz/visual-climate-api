class DataCategory < ActiveRecord::Base
  include Import

  has_many :data_category_data_sets
  has_many :data_sets, through: :data_category_data_sets
  has_many :data_category_data_types
  has_many :data_types, through: :data_category_data_types

  @sync_type = :datacategories
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
