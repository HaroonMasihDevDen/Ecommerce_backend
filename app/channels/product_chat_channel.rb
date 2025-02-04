class ProductChatChannel < ApplicationCable::Channel
  def subscribed
    product = Product.find(params[:product_id])
    stream_for product
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
