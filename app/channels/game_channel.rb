class GameChannel < ApplicationCable::Channel
  CHANNEL_NAME = "game_channel"
  def subscribed
    # stream_from "some_channel"
    stream_from CHANNEL_NAME
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.info "unsubscribed"
  end

  def receive(data)
    Rails.logger.info "receive called with data: #{data.inspect}"
  end

  def handle_data(data)
    Rails.logger.info "handle called with data: #{data.inspect}"
  end
end
