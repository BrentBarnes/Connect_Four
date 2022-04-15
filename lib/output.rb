require 'colorize'

class Output

  attr_reader :red_circle, :yellow_circle

  def initialize
   @red_circle = "\u2b24".encode('utf-8').colorize(:red)
   @yellow_circle = "\u2b24".encode('utf-8').colorize(:yellow)
  end

  def introduction
    puts 'Welcome to connect 4!'
    puts 'Your goal is to align 4 of your pieces in a row.'
    puts 'You can align them horizontally, vertically, or diagonally.'
    puts 'Align 4 in a row before your opponent to win!'
    puts
    puts "Player 1, you are playing red #{red_circle}"
    puts "Player 2, you are playing yellow #{yellow_circle}"
    puts
  end

  def turn_output(player1_turn)
    if player1_turn
      puts "Player 1 #{red_circle}, place your piece by selecting a column (1-7)"
    else
      puts "Player 2 #{yellow_circle}, place your piece by selecting a column (1-7)"
    end
    puts
  end

  def game_over_output(player1_turn)
    if player1_turn
      puts "Player 1 wins! Would you like a rematch?"
    else
      puts "Player 2 wins! Would you like a rematch?"
    end
  end
end
