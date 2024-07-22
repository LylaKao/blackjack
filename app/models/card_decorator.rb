class CardDecorator < Draper::Decorator
  delegate_all

  def suit_icon
    case suit
      when 'heart' then "♥"
      when 'diamond' then "♦"
      when 'club' then "♣"
      when 'spade' then "♠"
    end
  end

  def seeable?(idx, user_status = nil)
    ENV['DEBUG'] || !Game.last.started? || idx != 0 || user_status == 'lose'
  end

  def to_s
    "#{suit_icon.html_safe} #{rank}"
  end

  def hidden_icon
    "🂠🂠"
  end
end
