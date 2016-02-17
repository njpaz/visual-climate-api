class DataCategory < ActiveRecord::Base
  include Import

  belongs_to :data_set
  has_many :data_types

  has_many :data_category_data_types
  has_many :data_types, through: :data_category_data_types
  has_many :data_category_locations
  has_many :locations, through: :data_category_locations
  has_many :data_category_stations
  has_many :stations, through: :data_category_stations

  @sync_type = :datacategories
  @import_columns = [:identifier, :name]

  def self.sync_type
    @sync_type
  end

  def self.sync_id
    key_name = name.underscore + '_id'
    key_name.to_sym
  end

  def self.populate_belongs_to
    sync = NOAASync.new
    missing_sets = DataSet.where.not(id: pluck(:data_set_id))

    missing_sets.each do |set|
      data = sync.datacategories(params: { 'limit' => 1000, 'datasetid' => set.identifier })
      related_categories = data['results'].map { |dr| dr['id'] }

      where(identifier: related_categories).update_all(data_set_id: set.id)
    end
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
