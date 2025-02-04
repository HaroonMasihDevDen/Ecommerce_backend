class ChatSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
            :question,
            :answer,
            :user_name,
            :created_at

  def user_name
    object.user.name
  end
end
