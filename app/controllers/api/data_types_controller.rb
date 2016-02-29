class API::DataTypesController < API::BaseController
  def index
    @data_types = if params[:id]
      DataType.where(id: params[:id])
    elsif params[:identifier]
      DataType.where(identifier: params[:identifier])
    else
      DataType.all
    end

    render json: @data_types
  end

  def show
    render json: DataType.find(params[:id])
  end
end
