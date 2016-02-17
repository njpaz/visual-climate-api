class API::DataCategoriesController < API::BaseController
  def index
    render json: DataCategory.all
  end

  def show
    render json: DataCategory.find(params[:id])
  end
end
