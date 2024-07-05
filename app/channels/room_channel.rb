class RoomChannel < ApplicationCable::Channel
  CHANNEL_NAME = 'room_channel'

  def subscribed
    # stream_from "some_channel"
    stream_from CHANNEL_NAME
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Rails.logger.info "speak called with data: #{data.inspect}"
    Message.create!(content: data['msg'])
    ActionCable.server.broadcast(CHANNEL_NAME, data)
  end
end
