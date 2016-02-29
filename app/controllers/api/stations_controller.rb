class API::StationsController < API::BaseController
  def index
    @stations = if params[:id]
      Station.where(id: params[:id])
    elsif params[:identifier]
      Station.where(identifier: params[:identifier])
    else
      Station.all
    end

    render json: @stations
  end

  def show
    render json: Station.find(params[:id])
  end
end
