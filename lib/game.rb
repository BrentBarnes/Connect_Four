
require 'pry-byebug'
require 'colorize'
require_relative 'board.rb'
require_relative 'output.rb'

class Game

  attr_accessor :board, :output, :player1_turn, :game_over, :current_space, :empty, :red_circle, :yellow_circle

  def initialize(board=Board.new, output=Output.new)
    @board = board
    @output = output
    @player1_turn = true
    @game_over = false
    @current_space = nil
    @empty = "\u25ef".encode('utf-8')
    @red_circle = "\u2b24".encode('utf-8').colorize(:red)
    @yellow_circle = "\u2b24".encode('utf-8').colorize(:yellow)
  end

  def play_game
    output.introduction
    player_turn until game_over
  end

  def player_turn
    output.turn_output(player1_turn)
    board.build_board
    place_piece
    game_over?(current_space)
    change_player_turn(player1_turn)
  end

  def change_player_turn(player1_turn)
    player1_turn ? @player1_turn = false : @player1_turn = true
  end

  def get_selection
    selection = gets.to_i
    if selection.between?(1,7)
      selection
    else
      puts "Select a valid column (1-7)."
      get_selection
    end
  end

  def place_piece
    column = get_selection - 1
    
    row = 5
    until row < 0 do
      if board.space_empty?(row, column)
        player1_turn ? board.board[row][column] = red_circle : board.board[row][column] = yellow_circle
        @current_space = [row, column]
        return
      elsif !board.space_empty?(0, column)
        puts 'Column is full. Choose another column.'
        return place_piece
      elsif !board.space_empty?(row, column)
        row -= 1
      end
    end
  end

  def valid_row_and_column(r, c, piece)
    if  r.between?(0,5) && c.between?(0,6) &&
        !board.board[r].nil? &&
        !board.board[r][c].nil? &&
        board.board[r][c] == piece
      true
    else
      false
    end
  end

  def count_horizontal(row, column)
    piece = board.board[row][column]
    counter = 0

    c = column
    while valid_row_and_column(row,c,piece) do
      counter += 1
      c += 1
    end
    c = column-1
    while valid_row_and_column(row,c,piece) do
      counter += 1
      c -= 1
    end
    counter
  end

  def count_vertical(row, column)
    piece = board.board[row][column]
    counter = 0

    r = row
    while valid_row_and_column(r,column,piece) do
      counter += 1
      r += 1
    end
    r = row-1
    while valid_row_and_column(r,column,piece) do
      counter += 1
      r -= 1
    end
    counter
  end

  def count_positive_diagonal(row, column)
    piece = board.board[row][column]
    counter = 0

    r = row ; c = column
    while valid_row_and_column(r,c,piece) do
      counter += 1
      r -= 1
      c += 1
    end
    r = row+1 ; c = column-1
    while valid_row_and_column(r,c,piece) do
      counter += 1
      r += 1
      c -= 1
    end
    counter
  end

  def count_negative_diagonal(row, column)
    piece = board.board[row][column]
    counter = 0

    r = row ; c = column
    while valid_row_and_column(r,c,piece) do
      counter += 1
      r += 1
      c += 1
    end
    r = row-1 ; c = column-1
    while valid_row_and_column(r,c,piece) do
      counter += 1
      r -= 1
      c -= 1
    end
    counter
  end

  def horizontal_win?(row, column)
    count_horizontal(row, column) == 4 ? true : false
  end

  def vertical_win?(row, column)
    count_vertical(row, column) == 4 ? true : false
  end

  def positive_diagonal_win?(row, column)
    count_positive_diagonal(row, column) == 4 ? true : false
  end

  def negative_diagonal_win?(row, column)
    count_negative_diagonal(row, column) == 4 ? true : false
  end

  def game_over?(current_space)
    row = current_space[0] ; column = current_space[1]
    if  horizontal_win?(row,column) ||
        vertical_win?(row,column) ||
        positive_diagonal_win?(row,column) ||
        negative_diagonal_win?(row,column)
      @game_over = true
      board.build_board
      output.game_over_output(player1_turn)
    else
      @game_over = false
    end
  end
end
