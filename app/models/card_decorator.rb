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

  def to_s
    "#{suit_icon.html_safe} #{rank}"
  end

  def hidden_icon
    "🂠🂠"
  end
end
