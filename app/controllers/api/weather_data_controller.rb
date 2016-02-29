class API::WeatherDataController < API::BaseController
  def index
    @weather_data = if params[:station_id] && params[:data_type_id]
      WeatherDatum.where(station_id: params[:station_id], data_type_id: params[:data_type_id])
    elsif params[:station_identifier] && params[:data_type_identifier]
      WeatherDatum.joins(:station, :data_type).where(stations: {identifier: params[:station_identifier]}, data_types: {identifier: params[:data_type_identifier]})
    else
      WeatherDatum.all
    end

    render json: @weather_data
  end

  def show
    render json: WeatherDatum.find(params[:id])
  end
end
