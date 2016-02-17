class LocationCategory < ActiveRecord::Base
  include Import

  belongs_to :data_set
  has_many :locations
  has_many :data_set_location_categories
  has_many :data_sets, through: :data_set_location_categories

  @sync_type = :locationcategories
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
      data = sync.locationcategories(params: { 'limit' => 1000, 'datasetid' => set.identifier })
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
