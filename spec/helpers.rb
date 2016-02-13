module Helpers
  def stub_response(response, url)
    stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/#{url}/").
      with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
      to_return(status: 200, body: response.to_json, headers: {:content_type => 'application/json'})

    results = response[:results]
    first_result = results[0]
    single_response = { metadata: response[:metadata], results: [first_result] }

    stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/#{url}/?limit=1&offset=0").
      with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
      to_return(status: 200, body: single_response.to_json, headers: { content_type: 'application/json' })

    offset = 2
    results[1..-1].each_slice(1000) do |result_slice|
      current_response = { metadata: response[:metadata], results: result_slice }

      stub_request(:get, "http://ncdc.noaa.gov/cdo-web/api/v2/#{url}/?limit=1000&offset=#{offset}").
        with(headers: {'Token'=>Rails.application.secrets.NOAA_API_KEY}).
        to_return(status: 200, body: current_response.to_json, headers: {:content_type => 'application/json'})

      offset += 1000
    end
  end

  def create_response(count, has_dates=false)
    results = []

    count.times do
      params = { name: Faker::Lorem.sentence, id: Faker::Lorem.characters(10) }

      if has_dates
        min_date = Faker::Date.backward(300 * 365)
        max_date = Faker::Date.between(min_date, Date.today)

        params = params.merge({ mindate: min_date.strftime, maxdate: max_date.strftime })
      end

      results << params
    end

    {
      metadata: {
        resultset: {
          offset: 1,
          count: count,
          limit: 25
        }
      },
      results: results
    }
  end
end
