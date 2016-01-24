class NOAASync
  include HTTParty
  base_uri "ncdc.noaa.gov/cdo-web/api/v2"

  # sorting options:
  # sortfield
  # sortorder
  # limit
  # offset

  # notes:
  # can have more than one id (dataset, locationid, etc)

  def initialize
    @options = { headers: { "token" => Rails.application.secrets.NOAA_API_KEY } }
  end

  def datasets(options = {})
    # available:
    # datatypeid
    # locationid
    # stationid
    # startdate
    # enddate

    query = format_query(options)
    self.class.get("/datasets/#{query}", @options)
  end

  def datacategories(options = {})
    # available:

    # datasetid
    # locationid
    # stationid
    # startdate
    # enddate

    query = format_query(options)
    self.class.get("/datacategories/#{query}", @options)
  end

  def datatypes(options = {})
    # available:

    # datasetid
    # locationid
    # stationid
    # datacategoryid
    # startdate
    # enddate


    query = format_query(options)
    self.class.get("/datatypes/#{query}", @options)
  end

  def locationcategories(options = {})
    # available:

    # datasetid
    # startdate
    # enddate

    query = format_query(options)
    self.class.get("/locationcategories/#{id}", @options)
  end

  def locations(options = {})
    # available:

    # datasetid
    # locationcategoryid
    # datacategoryid
    # startdate
    # enddate

    query = format_query(options)
    self.class.get("/locations/#{id}", @options)
  end

  def stations(options = {})
    # available:

    # datasetid
    # locationid
    # datacategoryid
    # datatypeid
    # extent
    # startdate
    # enddate


    # sorting options:
    # sortfield
    # sortorder
    # limit
    # offset

    query = format_query(options)
    self.class.get("/stations/#{id}", @options)
  end

  def data(options = {})
    # available:

    # datasetid !required
    # datatypeid
    # locationid
    # stationid
    # startdate !required
    # enddate !required

    query = format_query(options)
    self.class.get("/data?datasetid=#{dataset_id}&startdate=#{start_date}&enddate=#{end_date}", @options)
  end

  private

  def format_query(options)
    id = options.delete("id")
    query = ""
    query += "id=#{id}" unless id.nil?

    options.reduce(query) do |prev, curr|
      key, value = curr
      prev += "&#{key}=#{value}"
    end
  end
end
