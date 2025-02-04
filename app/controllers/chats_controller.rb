class ChatsController < ApplicationController
  def create
    product = Product.find(params[:product_id])

    chat = product.chats.new(chat_params)
    if chat.save!
      ActionCable.server.broadcast(
        "product_chat_#{product.id}",
        {
          message: chat.question, 
          user_name: chat.user.name, 
          timestamps: chat.created_at
        }
      )
      head :ok
    else
      render json: { error: 'Failed to send message' }, status: :unprocessable_entity
      head :unprocessable_entity
    end
  end

  private 

  def chat_params
    params.require(:chat).permit(:question, :user_id)
  end
end
