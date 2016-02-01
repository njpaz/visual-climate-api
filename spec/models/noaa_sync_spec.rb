require 'rails_helper'

RSpec.describe NOAASync do
  include HTTParty

  let(:noaa_sync) do
    NOAASync.new
  end

  context 'datasets' do
    context 'with no options', vcr: { cassette_name: 'datasets' } do
      it 'returns all datasets if there are no options' do
        response = noaa_sync.datasets

        expect(response['results'].length).to eq(11)
        expect(response['results'][0]['mindate']).to eq('1831-02-01')
        expect(response['results'][0]['maxdate']).to eq('2015-06-01')
        expect(response['results'][0]['name']).to eq('Annual Summaries')
         expect(response['results'][0]['id']).to eq('ANNUAL')
      end
    end

    context 'with id', vcr: { cassette_name: 'datasets_id' } do
      it 'returns all data for a single dataset if it includes an id' do
        response = noaa_sync.datasets(id: 'ANNUAL')

         expect(response['name']).to eq('Annual Summaries')
        expect(response['id']).to eq('ANNUAL')
      end
    end

    context 'with additional parameters', vcr: { cassette_name: 'datasets_params' } do
      it 'returns all relevant data when given additional parameters' do
        parameters = {
          'datatypeid' => 'ACMH',
          'locationid' => 'FIPS:37'
        }

        response = noaa_sync.datasets(params: parameters)

        expect(response['results'].length).to eq(1)
        expect(response['results'][0]['name']).to eq('Daily Summaries')
        expect(response['results'][0]['id']).to eq('GHCND')
      end
    end
  end

  context 'datacategories' do
    context 'with no options', vcr: { cassette_name: 'datacategories' } do
      it 'receives all datacategories if there are no options' do
        response = noaa_sync.datacategories

        expect(response['results'].length).to eq(25)
        expect(response['results'][0]['name']).to eq('Annual Agricultural')
        expect(response['results'][0]['id']).to eq('ANNAGR')
      end
    end

    context 'with id', vcr: { cassette_name: 'datacategories_id' } do
      it 'receives all data for a single dataset if it includes an id' do
        response = noaa_sync.datacategories(id: 'ANNAGR')

        expect(response['name']).to eq('Annual Agricultural')
        expect(response['id']).to eq('ANNAGR')
      end
    end

    context 'with additional parameters', vcr: { cassette_name: 'datacategories_params' } do
      it 'receives all relevant data when given additional parameters' do
        parameters = {
          'datasetid' => 'ANNUAL',
          'locationid' => 'CITY:US390029'
        }

        response = noaa_sync.datacategories(params: parameters)

        expect(response['results'].length).to eq(3)
        expect(response['results'][0]['name']).to eq('Computed')
        expect(response['results'][0]['id']).to eq('COMP')
      end
    end
  end

  context 'datatypes' do
    context 'with no options', vcr: { cassette_name: 'datatypes' } do
      it 'returns all datatypes if there are no options' do
        response = noaa_sync.datatypes

        expect(response['results'].length).to eq(25)
        expect(response['results'][0]['name']).to eq('Average cloudiness midnight to midnight from 30-second ceilometer data (percent)')
        expect(response['results'][0]['id']).to eq('ACMC')
      end
    end

    context 'with id', vcr: { cassette_name: 'datatypes_id' } do
      it 'returns all data for a single dataset if it includes an id' do
        response = noaa_sync.datatypes(id: 'ACMC')

        expect(response['id']).to eq('ACMC')
      end
    end

    context 'with additional parameters', vcr: { cassette_name: 'datatypes_params' } do
      it 'returns all relevant data when given additional parameters' do
        parameters = {
          'datasetid' => 'ANNUAL',
          'locationid' => 'CITY:US390029'
        }

        response = noaa_sync.datatypes(params: parameters)

        expect(response['results'].length).to eq(21)
        expect(response['results'][0]['name']).to eq('Cooling degree days')
        expect(response['results'][0]['id']).to eq('CLDD')
      end
    end
  end

  context 'data' do
    context 'with no optional parameters', vcr: { cassette_name: 'data' } do
      it 'returns all data for a specific dataset in a specified range' do
        response = noaa_sync.data(datasetid: 'ANNUAL', startdate: '2010-10-03', enddate: '2012-09-10')

        expect(response['results'].length).to eq(25)
        expect(response['results'][0]['date']).to eq('2010-11-01T00:00:00')
        expect(response['results'][0]['datatype']).to eq('CLDD')
        expect(response['results'][0]['station']).to eq('COOP:010063')
      end
    end

    context 'with extra parameters', vcr: { cassette_name: 'data_params' } do
      it 'returns all data for the specified dataset with the additional parameters' do
        response = noaa_sync.data(datasetid: 'GHCND', startdate: '2010-05-01', enddate: '2010-05-01', params: {'locationid' => 'ZIP:28801'})

        expect(response['results'].length).to eq(8)
        expect(response['results'][0]['date']).to eq('2010-05-01T00:00:00')
        expect(response['results'][0]['datatype']).to eq('PRCP')
        expect(response['results'][0]['station']).to eq('GHCND:US1NCBC0005')
      end
    end
  end
end
