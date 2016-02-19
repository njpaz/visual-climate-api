class API::WeatherDataController < API::BaseController
  def index
    @weather_data = if params[:station_id] && params[:data_type_id]
      WeatherDatum.where(station_id: params[:station_id], data_type_id: params[:data_type_id])
    else
      WeatherDatum.all
    end

    render json: @weather_data
  end

  def show
    render json: WeatherDatum.find(params[:id])
  end
end
