class API::WeatherDataController < API::BaseController
  def index
    render json: WeatherDatum.all
  end

  def show
    render json: WeatherDatum.find(params[:id])
  end
end
