class PaymentsController < ApplicationController
  require 'stripe'

  def create
    begin
      payment_intent = Stripe::PaymentIntent.create({
        amount: params[:amount],
        currency: params[:currency] || 'pkr',
        payment_method: params[:payment_method_id],
        confirmation_method: 'automatic',
        confirm: true,
        return_url: 'http://localhost:3000/payment-success',  # Change this URL to match your frontend
      })

      render json: { success: true, payment_intent: payment_intent }
    rescue Stripe::StripeError => e
      render json: { success: false, error: e.message }, status: 400
    end
  end
end
