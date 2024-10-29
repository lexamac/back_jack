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
        return true if option == 'e'

        decision = player.make_decision(option)
        case decision
        when :add_card
          player.take_card(@deck.pull!)
          @bank.topup(player.give_money(10))
        when :show_cards then @finished = true
        when :skip then @bank.topup(player.give_money(10))
        end

        @finished ||= @players[0].size == 3 || @players[1].size == 3
      end
    end

    show_summary
    false
  end

  def round?
    @finished
  end

  def results
    show_summary
  end

  private

  def init_round
    if (!@name)
      print 'What is your name?: '
      @name = gets.chomp.to_s
      @player = Player.new(@name)
      @players << @player
    end

    @bank = Bank.new(0)
    @deck = Deck.new
    @finished = false
    begin
      @players.each do |player|
        player.free_cards
        2.times { player.take_card(@deck.pull!) }
        @bank.topup(player.give_money(10))
      end
    rescue Error => e
      puts 'One of players doesn\'t have enough money. Game ended!'
    end
  end

  def show_summary
    puts
    puts "Current Round Bank: $#{@bank.bank}"
    puts
    if @finished
      winner = nil
      if @players[1].score(true) >= @players[0].score(true) && @players[1].score(true) <= 21
        winner = @players[1].name
        @players[1].take_money(@bank.bank)
      elsif @players[0].score(true) <= 21
        winner = 'Game Dealer'
        @players[0].take_money(@bank.bank)
      end
      puts "Congratualtions, #{winner} wins the round!" if winner
      puts
    end
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
    puts('E/e - Exit')

    gets.chomp.to_s.chomp
  end
end
