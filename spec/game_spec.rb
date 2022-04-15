require 'game'
require 'output'
require 'pry-byebug'

describe Game do

  describe '#get_selection' do
    context 'when player enters a valid number' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'returns the number' do
        allow(game).to receive(:gets).and_return(4)
        expect(game.get_selection).to eq(4)
      end
    end

    context 'when player enters an invalid number' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'outputs Select a valid column (1-7).' do
        allow(game).to receive(:gets).and_return(9, 2)
        retry_phrase = "Select a valid column (1-7).\n"
        expect { game.get_selection }.to output(retry_phrase).to_stdout
      end

      it 'calls get_selection again' do
        allow(game).to receive(:gets).and_return(9, 2)
        expect(game).to receive(:get_selection).and_call_original.twice
        game.get_selection
      end
    end
  end

  describe '#place_piece' do
    context 'when player selects column' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'places a piece in the empty space in row 0' do
        allow(game).to receive(:get_selection).and_return(3)
        game.place_piece
        space = game.board.board[5][2]
        empty = game.board.empty

        expect(space).not_to be(empty)
      end

      it 'places a piece in the empty space above another piece' do
        allow(game).to receive(:get_selection).and_return(4, 4)
        2.times { game.place_piece }
        space = game.board.board[4][3]
        empty = game.board.empty

        expect(space).not_to be(empty)
      end

      context 'when column is filled with pieces' do
        subject(:game) {described_class.new(Board.new, Output.new)}
        it 'calls place_piece again' do
          fill_column(0)
          
          allow(game).to receive(:get_selection).and_return(1,2)
          expect(game).to receive(:place_piece).and_call_original.twice
          game.place_piece
        end
      end

      context 'when player1_turn is true' do
        subject(:game) { described_class.new(Board.new, Output.new)}
        let(:red_circle) { "\u2b24".encode('utf-8').colorize(:red) }
        it 'places a red piece' do
          allow(game).to receive(:get_selection).and_return(1)
          game.place_piece
          expect(game.board.board[5][0]).to eq(red_circle)
        end
      end

      context 'when player1_turn is false' do
        subject(:game) { described_class.new(Board.new, Output.new)}
        let(:yellow_circle) { "\u2b24".encode('utf-8').colorize(:yellow) }

        it 'places a yellow piece' do
          game.instance_variable_set(:@player1_turn, false)
          allow(game).to receive(:get_selection).and_return(1)
          game.place_piece
          expect(game.board.board[5][0]).to eq(yellow_circle)
        end
      end
    end
  end

  describe '#count_horizontal' do
    context 'when there are two pieces to the right' do
      subject(:game) {described_class.new(Board.new, Output.new)}
      it 'includes original piece and returns 3' do
        add_horizontal(3)
        expect(game.count_horizontal(5,0)).to eq(3)
      end
    end

    context 'when there are 2 pieces to the left' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes original piece and returns 3' do
        add_horizontal(3)
        expect(game.count_horizontal(5,2)).to eq(3)
      end
    end

    context 'when there are 0 pieces to the left' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes original piece and returns 1' do
        add_horizontal(1)
        expect(game.count_horizontal(5,0)).to eq(1)
      end
    end

    context 'when there are 0 pieces to the right' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original space and returns 1' do
        add_horizontal(1)
        expect(game.count_horizontal(5,0)).to eq(1)
      end
    end
  end

  describe '#count_vertical' do
    context 'when there is one piece' do
      subject(:game) {described_class.new(Board.new, Output.new)}
      it 'includes original piece and returns 1' do
        add_vertical(1)
        expect(game.count_vertical(5,0)).to eq(1)
      end
    end

    context 'when there are 2 pieces from bottom' do
      subject(:game) {described_class.new(Board.new, Output.new)}
      it 'includes original piece and returns 2' do
        add_vertical(2)
        expect(game.count_vertical(5,0)).to eq(2)
      end
    end

    context 'when there are 2 pieces from top' do
      subject(:game) {described_class.new(Board.new, Output.new)}
      it 'includes original piece and returns 2' do
        add_vertical(2)
        expect(game.count_vertical(4,0)).to eq(2)
      end
    end

    context 'when there are 4 pieces from 2nd from bottom' do
      subject(:game) {described_class.new(Board.new, Output.new)}
      it 'includes original piece and returns 4' do
        add_vertical(4)
        expect(game.count_vertical(4,0)).to eq(4)
      end
    end
  end

  describe '#count_positive_diagonal' do
    context 'when there is 1 piece' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 1' do
        add_positive_diagonal(1)
        expect(game.count_positive_diagonal(5,0)).to eq(1)
      end
    end

    context 'when there are 2 pieces starting from bottom' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 2' do
        add_positive_diagonal(2)
        expect(game.count_positive_diagonal(5,0)).to eq(2)
      end
    end

    context 'when there are 2 pieces starting from top' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 2' do
        add_positive_diagonal(2)
        expect(game.count_positive_diagonal(4,1)).to eq(2)
      end
    end

    context 'when there are 4 pieces starting from 2 from left' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 4' do
        add_positive_diagonal(4)
        expect(game.count_positive_diagonal(3,2)).to eq(4)
      end
    end
  end

  describe '#count_negative_diagonal' do
    context 'when there is 1 piece' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 1' do
        add_negative_diagonal(1)
        expect(game.count_negative_diagonal(2,0)).to eq(1)
      end
    end

    context 'when there are 2 pieces' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 2' do
        add_negative_diagonal(2)
        expect(game.count_negative_diagonal(2,0)).to eq(2)
      end
    end

    context 'when there are 2 pieces starting from 2' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 2' do
        add_negative_diagonal(2)
        expect(game.count_negative_diagonal(3,1)).to eq(2)
      end
    end

    context 'when there are 4 pieces starting from 2' do
      subject(:game) { described_class.new(Board.new, Output.new) }
      it 'includes the original piece and returns 4' do
        add_negative_diagonal(4)
        expect(game.count_negative_diagonal(3,1)).to eq(4)
      end
    end
  end

  describe '#horizontal_win?' do
    subject(:game) { described_class.new(Board.new, Output.new) }

    context 'when player has 4 in a row horizontally to the right' do
      it 'returns true' do
        add_horizontal(4)
        expect(game.horizontal_win?(5,0)).to be true
      end
    end

    context 'when player has 4 in a row horizontally to the left' do
      it 'returns true' do
        add_horizontal(4)
        expect(game.horizontal_win?(5,3)).to be true
      end
    end

    context 'when player has 4 in a row horizontally to the right and left' do
      it 'returns true' do
        add_horizontal(4)
        expect(game.horizontal_win?(5,2)).to be true
      end
    end

    context 'when player does not have 4 in a row horizontally' do
      it 'returns false' do
        add_horizontal(3)
        expect(game.horizontal_win?(5,1)).to be false
      end
    end
  end

  describe '#vertical_win?' do
    subject(:game) { described_class.new(Board.new, Output.new) }

    context 'when player has 4 in a row going up' do
      it 'returns true' do
        add_vertical(4)
        expect(game.vertical_win?(5,0)).to be true
      end
    end

    context 'when player has 3 in a row going up' do
      it 'returns false' do
        add_vertical(3)
        expect(game.vertical_win?(5,0)).to be false
      end
    end
  end

  describe '#positive_diagonal_win?' do
    subject(:game) { described_class.new(Board.new, Output.new) }

    context 'when player has 4 in a row going up and to the right' do
      it 'returns true' do
        add_positive_diagonal(4)
        expect(game.positive_diagonal_win?(5,0)).to be true
      end
    end

    context 'when player has 3 in a row going up and to the right' do
      it 'returns false' do
        add_positive_diagonal(3)
        expect(game.positive_diagonal_win?(5,0)).to be false
      end
    end
  end

  describe '#negative_diagonal_win?' do
    subject(:game) { described_class.new(Board.new, Output.new) }

    context 'when player has 4 in a row going down and to the right' do
      it 'returns true' do
        add_negative_diagonal(4)
        expect(game.negative_diagonal_win?(2,0)).to be true
      end
    end

    context 'when player has 3 in a row going down and to the right' do
      it 'returns false' do
        add_negative_diagonal(3)
        expect(game.negative_diagonal_win?(2,0)).to be false
      end
    end
  end

  describe '#game_over' do
    subject(:game) { described_class.new(Board.new,Output.new) }
    context 'when horizontal_win? is true' do
      it 'sets returns true' do
        add_horizontal(4)
        game.game_over?([5,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end
    end

    context 'when horizontal_win? is false' do
      it 'sets returns false' do
        add_horizontal(3)
        game.game_over?([5,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be false
      end
    end
    
    context 'when vertical_win? is true' do
      it 'sets returns true' do
        add_vertical(4)
        game.game_over?([5,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end
    end

    context 'when vertical_win? is false' do
      it 'sets returns false' do
        add_vertical(2)
        game.game_over?([5,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be false
      end
    end

    context 'when positive_diagonal_win? is true' do
      it 'sets returns true' do
        add_positive_diagonal(4)
        game.game_over?([5,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end
    end  

    context 'when positive_diagonal_win? is false' do
      it 'sets returns false' do
        add_positive_diagonal(3)
        game.game_over?([5,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be false
      end
    end
    
      
    context 'when negative_diagonal_win? is true' do
      it 'sets returns true' do
        add_negative_diagonal(4)
        game.game_over?([2,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be true
      end
    end

    context 'when negative_diagonal_win? is false' do
      it 'sets returns false' do
        add_negative_diagonal(3)
        game.game_over?([2,0])
        game_over = game.instance_variable_get(:@game_over)
        expect(game_over).to be false
      end
    end
  end
  
  describe '#change_player_turn' do
    subject(:game) { described_class.new(Board.new, Output.new) }
    context 'after the end of player 1\'s turn' do
      it 'changes player1_turn to false' do
        game.change_player_turn(game.player1_turn)
        expect(game.player1_turn).to be false
      end
    end

    context 'after the end of player 2\'s turn' do
      it 'changes player1_turn to true' do
        game.instance_variable_set(:@player1_turn, false)
        game.change_player_turn(game.player1_turn)
        expect(game.player1_turn).to be true
      end
    end
  end
    
end


#Helper Methods

def fill_column(column)
  row = 5
  until row < 0 do
    game.board.board[row][column] = 'taken'
    row -= 1
  end
end

def add_horizontal(number_of_spaces)
  number_of_spaces -= 1
  row = 5
  column = 0
  until column > number_of_spaces do
    game.board.board[row][column] = "\u2b24".encode('utf-8').colorize(:red)
    column += 1
  end
end

def add_vertical(number_of_spaces)
  number_of_spaces -= 1
  row = 5
  column = 0
  i = 0
  until i > number_of_spaces do
    game.board.board[row][column] = "\u2b24".encode('utf-8').colorize(:red)
    row -= 1
    i += 1
  end
end

def add_positive_diagonal(number_of_spaces)
  number_of_spaces -= 1
  row = 5
  column = 0
  until column > number_of_spaces do
    game.board.board[row][column] = "\u2b24".encode('utf-8').colorize(:red)
    column += 1
    row -= 1
  end
end

def add_negative_diagonal(number_of_spaces)
  number_of_spaces -= 1
  row = 2
  column = 0
  until column > number_of_spaces do
    game.board.board[row][column] = "\u2b24".encode('utf-8').colorize(:red)
    column += 1
    row += 1
  end
end