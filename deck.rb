require_relative 'card'

# a deck class for holding all cards
class Deck
  attr_reader :card_deck

  def initialize
    init_deck
  end

  def pull!
    @card_deck.pop
  end

  def shuffle!
    @card_deck.shuffle!
  end

  private

  def init_deck
    @card_deck = Card::VALUES.product(Card::SUITS).collect { |value, suit| Card.new(value, suit) }
    @card_deck.shuffle!
  end
end
