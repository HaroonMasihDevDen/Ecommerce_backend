class StockAlertChannel < ApplicationCable::Channel
  def subscribed
    stream_from "stock_alert_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
