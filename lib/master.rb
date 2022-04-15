
require_relative 'game.rb'
require_relative 'output.rb'
require_relative 'board.rb'

class Master

  def play
    game = Game.new(Board.new, Output.new)
    game.play_game
    rematch
  end

  def rematch
    reply = gets.chomp.downcase
    if reply == 'y'
      play
    elsif reply == 'n'
      puts 'Bye!'
    else
      puts "Please type a valid response ('y' or 'n')"
      rematch
    end
  end
end
