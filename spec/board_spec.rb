
require 'board'
require 'pry-byebug'

describe Board do
  describe '#space_empty?' do
    
    context 'when space is empty' do
      subject(:board) { described_class.new }
      it 'returns true' do
        expect(board.space_empty?(5,0)).to be true
      end
    end

    context 'when space is taken' do
      subject(:board) { described_class.new }
      it 'returns false' do
        board.board[5][0] = 'taken'
        expect(board.space_empty?(5,0)).to be false
      end
    end
  end
end