require 'pry-byebug'

class Board

  attr_accessor :empty, :board

  def initialize
    @empty = "\u25ef".encode('utf-8')
    @board = Array.new(6) {Array.new(7, empty)}
  end

  def build_board
    board.each do |column|
      puts column.join(' ')
    end
    puts '1 2 3 4 5 6 7'
  end

  def space_empty?(row, column)
    board[row][column] == empty ? true : false
  end
end
