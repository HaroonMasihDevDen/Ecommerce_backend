class ChatsController < ApplicationController
  def create
    product = Product.find(params[:product_id])

    chat = product.chats.new(chat_params)
    if chat.save!
      ActionCable.server.broadcast(
        "product_chat_#{product.id}",
        {
          question: chat.question, 
          user_name: chat.user.name, 
          created_at: chat.created_at,
          updated_at: chat.updated_at,
          id: chat.id,
          action: 'create'
        }
      )
      head :ok
    else
      render json: { error: 'Failed to send message' }, status: :unprocessable_entity
      head :unprocessable_entity
    end
  end

  def get_all_chats
    chats = Chat.all.order(created_at: :desc, answer: :desc)
    render json: chats, each_serializer: ChatSerializer
  end

  private 

  def chat_params
    params.require(:chat).permit(:question, :user_id)
  end
end
