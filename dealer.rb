require_relative 'human'
require_relative 'bank'

# class Dealer for game dealer
class Dealer < Human
  def initialize
    super('Game Dealer')
    @bank = Bank.new(100)
  end

  def make_decision(_decision)
    return :show_cards if @cards.length == 3
    return :add_card if @cards.map(&:cost).reduce(0, :+) < 17

    :skip
  end
end
