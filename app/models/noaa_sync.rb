class NOAASync
  include HTTParty
  base_uri "ncdc.noaa.gov/cdo-web/api/v2"

  def initialize
    @options = { headers: { "token" => Rails.application.secrets.NOAA_API_KEY } }
  end

  [:datasets, :datacategories, :datatypes, :locationcategories, :locations, :stations].each do |name|
    define_method name, ->(id: nil, params: {}) do
      id = "#{id}/" unless id.nil?
      parameters = format_parameters(params)

      self.class.get("/#{name.to_s}/#{id}#{parameters}", @options)
    end
  end

  def data(datasetid:, startdate:, enddate:, params: {})
    parameters = format_parameters(params, start_char: "&")
    self.class.get("/data?datasetid=#{datasetid}&startdate=#{startdate}&enddate=#{enddate}#{parameters}", @options)
  end

private

  def format_parameters(params, start_char: "?")
    params.reduce(start_char) do |prev, curr|
      key, value = curr
      prev += "#{key}=#{value}&"
    end
  end
end

