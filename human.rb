require_relative 'card'
require_relative 'bank'

# class Human, base class for Player and Dealer
class Human
  attr_accessor :name
  attr_reader :bank

  def initialize(name)
    @name = name
    @score = 0
    @cards = []
  end

  def take_card(card)
    @cards << card
  end

  def score(show)
    return '**' unless show

    @score = @cards.map(&:cost).reduce(0, :+)
    @score += 10 if @score + 10 <= 21 && @cards.any?(&:ace?)
    @score
  end

  def size
    @cards.size
  end

  def cards(show)
    return @cards.map { |card| "|#{card.back}|" }.join unless show

    @cards.map { |card| "|#{card.face}|" }.join
  end

  def give_money(value)
    raise Error.new('Not enough money in the bank') unless value < @bank.bank

    @bank.withdraw(value)
    value
  end

  def take_money(value)
    @bank.topup(value)
  end

  def make_decision(_decision)
    raise NotImplementedError.new('Method not implemented yet!')
  end
end
