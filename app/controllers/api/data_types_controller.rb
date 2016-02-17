class API::DataTypesController < API::BaseController
  def index
    render json: DataType.all
  end

  def show
    render json: DataType.find(params[:id])
  end
end
