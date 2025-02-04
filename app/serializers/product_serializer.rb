class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
              :name,
              :description,
              :discountPercentage,
              :price,
              :sizes,
              :base64_images,
              :chats

  def discountPercentage
    object.discount_percentage
  end

  def sizes
    object.product_sizes.map do |size|
      ProductSizeSerializer.new(size, scope: scope, root: false)
    end
  end

  def base64_images
    if object.images.attached?
      object.images.map do |image|
        "data:#{image.content_type};base64,#{Base64.strict_encode64(image.download)}"
      end
    end
  end

  def chats
    object.chats.map do |chat|
      ChatSerializer.new(chat, scope: scope, root: false)
    end
  end
end
