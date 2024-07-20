class Dealer < Player
  DEALER_ID = -1
  DEALER_NAME = "DEALER"
  DEALER_SEAT_ID = 0

  def initialize(seat_id = DEALER_SEAT_ID, bet = 0, user_id = DEALER_ID, name = DEALER_NAME )
    super(seat_id, bet, user_id, name)
  end

  def dealer?
    true
  end
end
