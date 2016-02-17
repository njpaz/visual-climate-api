class API::DataSetsController < API::BaseController
  def index
    render json: DataSet.all
  end

  def show
    render json: DataSet.find(params[:id])
  end
end
