class ProductsController < ApplicationController

  def index
    products = Product.where(deleted_at: nil)
    render json: products ,each_serializer: ProductSerializer
  end
end
