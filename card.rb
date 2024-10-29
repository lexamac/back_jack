# class for game cards
class Card
  attr_accessor :show
  attr_reader :suit, :value

  SUITS = ['♥', '♦', '♣', '♠']
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']

  def initialize(value, suit)
    @value = value
    @suit = suit
    @show = false
  end

  def face
    "#{value}#{suit}"
  end

  def back
    '**'
  end

  def ace?
    @suit == 'A'
  end

  def cost
    case @value
    when 'A'
      1
    when 2..10
      @value
    else
      10
    end
  end
end
