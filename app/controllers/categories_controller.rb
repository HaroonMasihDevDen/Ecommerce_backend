# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController

  def index
    categories = Category.where(parent_category_id: nil)
    render json: categories, each_serializer: CategorySerializer
  end

end
