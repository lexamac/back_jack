# class for bank operations
class Bank
  attr_reader :bank

  def initialize(bank)
    @bank = bank
  end

  def topup(value)
    @bank += value
  end

  def withdraw(value)
    @bank -= value
  end
end
