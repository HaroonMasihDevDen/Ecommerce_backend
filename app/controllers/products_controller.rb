class ProductsController < ApplicationController

  def index
    productWithSizeQuantity = ProductSize.where('quantity > ?',0).pluck(:product_id).uniq
    products = Product.active.where(id: productWithSizeQuantity)

    low_stock_product = Product.low_stock_products.first
    if low_stock_product && low_stock_product.total_stock <= 5
      ActionCable.server.broadcast 'stock_alert_channel', {
        type: "low_stock_alert",
        message: "Hurry! Only #{low_stock_product.total_stock} left in stock for #{low_stock_product.name}.",
        product_id: low_stock_product.id
      }
    end
    
    render json: products, each_serializer: ProductSerializer
  end

  def show
    product = Product.find(params[:id])
    render json: ProductSerializer.new(product).as_json
  end

  def search
    query = params[:query]
    products = Product.active
                 .ransack(
                   m: 'or',
                   name_eq: query,
                   name_cont: query,
                   description_cont: query
                 ).result
    render json: products, each_serializer: ProductSerializer , status: :ok
  end

  def filter
    sizes = params[:sizes]
    min_price = params[:min_price]
    max_price = params[:max_price]
    categories = params[:categories]

    if sizes.blank? && min_price.blank? && max_price.blank? && categories.blank?
      products = Product.active
    else
      products = Product.active.ransack(
        product_sizes_price_gteq: min_price,
        product_sizes_price_lteq: max_price,
        category_products_category_id_in: categories,
        sizes_key_in: sizes
      ).result(distinct: true)

      products = products.joins(:product_sizes) unless sizes.blank?
      products = products.joins(:category_products) unless categories.blank?
      products = products.joins(:sizes) unless (max_price.blank? && min_price.blank?)
    end

    render json: products, each_serializer: ProductSerializer , status: :ok
  end
end
