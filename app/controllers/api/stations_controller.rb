class API::StationsController < API::BaseController
  def index
    render json: Station.all
  end

  def show
    render json: Station.find(params[:id])
  end
end
