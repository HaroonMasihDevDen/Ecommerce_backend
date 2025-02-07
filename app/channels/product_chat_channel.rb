class ProductChatChannel < ApplicationCable::Channel
  def subscribed
    # product = Product.find(params[:product_id])
    # stream_for product

    stream_from "product_chat_#{params[:product_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    product = Product.find(data['product_id'])

    chat = product.chats.new(question: data['question'], user_id: data['user_id'])
    if chat.save
      ActionCable.server.broadcast("product_chat_#{data['product_id']}", {
        question: chat.question,
        answer: chat.answer,
        user_name: chat.user.name,
        created_at: chat.created_at,
        updated_at: chat.updated_at,
        id: chat.id,
        action: 'create'
      })
    else
      render json: { error: 'Failed to send message' }, status: :unprocessable_entity
      head :unprocessable_entity
    end
  end
end
