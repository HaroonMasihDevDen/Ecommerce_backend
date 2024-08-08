class ProductSerializer < ActiveModel::Serializer

  attributes :id,
              :name,
              :description,
              :discountPercentage,
              :price

  def price
    puts "this is the product_size: #{object.product_sizes.to_a}"
    object.product_sizes.where("quantity > ?",0).order(:price).first&.price
  end

  def discountPercentage
    object.discount_percentage
  end

end
