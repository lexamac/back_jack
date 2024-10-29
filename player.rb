require_relative 'human'
require_relative 'bank'

# class Player for game player
class Player < Human
  def initialize(name)
    super(name)
    @bank = Bank.new(100)
  end

  def make_decision(decision)
    case decision
    when 'a'
      return :show_cards if @cards.length == 3 || @cards.map(&:cost).reduce(0, :+) >= 17

      :add_card
    when 'o'
      :show_cards
    else
      :skip
    end
  end
end
