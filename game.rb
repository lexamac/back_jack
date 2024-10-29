require_relative 'card'
require_relative 'deck'
require_relative 'dealer'
require_relative 'player'
require_relative 'bank'

# main Game class
class Game
  def initialize
    @bank = Bank.new(0)
    @deck = Deck.new
    @players = [Dealer.new]

    @finished = false
  end

  def start
    init_round

    until @finished
      show_summary

      @players.each do |player|
        option = show_options.downcase if player.is_a? Player
        decision = player.make_decision(option)

        case decision
        when :add_card
          player.take_card(@deck.pull!)
          @bank.topup(player.give_money(10))
        when :show_cards then @finished = true
        when :skip then @bank.topup(player.give_money(10))
        end
      end
    end

    show_summary
  end

  def round?
    @finished
  end

  def results
    show_summary
  end

  private

  def init_round
    print 'What is your name?: '
    name = gets.chomp.to_s
    @player = Player.new(name)
    @players << @player

    @players.each do |player|
      2.times { player.take_card(@deck.pull!) }
      @bank.topup(player.give_money(10))
    end
  end

  def show_summary
    puts
    puts "Current Round Bank: $#{@bank.bank}"
    puts
    @players.each do |player|
      puts "#{player.name}'s:"
      puts "Bank:  $#{player.bank.bank}"
      puts "Score: #{player.score(@finished || player.is_a?(Player))}"
      puts "Cards: #{player.cards(@finished || player.is_a?(Player))}"
      puts
    end
  end

  def show_options
    puts
    puts 'Please select an option:'
    puts('P/p - Pass')
    puts('A/a - Add') if @player.size < 3
    puts('O/o - Open')

    gets.chomp.to_s.chomp
  end
end
