class ChatSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
            :question,
            :answer,
            :user_name,
            :product_name,
            :product_id,
            :created_at,
            :updated_at

  def user_name
    object.user.name
  end

  def product_name
    object.product.name
  end

  def product_id
    object.product.id
  end
end
