require 'game/components/pieces/index'
require_relative '../../../test_helper/h_piece'

describe Pieces do
  describe '#init' do
    it 'return an instance of piece with the right type and arguments' do
      expect(Pieces::init('k', [0, 0])).to equal_piece Pieces::King.new([0, 0], :b)
      expect(Pieces::init('q', [3, 3])).to equal_piece Pieces::Queen.new([3, 3], :b)
      expect(Pieces::init('r', [2, 2])).to equal_piece Pieces::Rook.new([2, 2], :b)
      expect(Pieces::init('B', [4, 4])).to equal_piece Pieces::Bishop.new([4, 4], :w)
      expect(Pieces::init('N', [0, 5])).to equal_piece Pieces::Knight.new([0, 5], :w)
      expect(Pieces::init('P', [6, 0])).to equal_piece Pieces::Pawn.new([6, 0], :w)
    end
  end
end
