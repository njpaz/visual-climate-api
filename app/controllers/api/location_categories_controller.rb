class API::LocationCategoriesController < API::BaseController
  def index
    render json: LocationCategory.all
  end

  def show
    render json: LocationCategory.find(params[:id])
  end
end
