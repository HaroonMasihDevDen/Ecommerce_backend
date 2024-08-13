class CartItemsController < ApplicationController

  include Authenticatable

  def create
    product_id = params[:product_id]
    size_id = params[:size_id]
    quantity = params[:quantity]
    user_id = @current_user.id

    existing_cart_item = CartItem.find_by(product_id: product_id, size_id: size_id, user_id: user_id)

    if existing_cart_item
      existing_cart_item.quantity += quantity
      if existing_cart_item.save
        render json: { message: 'Item quantity updated in cart successfully' ,status: 200}
      else
        render json: { errors: existing_cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    else
      cart_item = CartItem.new(product_id: product_id, size_id: size_id, quantity: quantity, user_id: user_id)
      if cart_item.save
        render json: { message: 'Item added to cart successfully' ,status: 200}
      else
        render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
