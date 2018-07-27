require 'game/components/pieces/index'
require_relative '../../../test_helper/h_piece'

describe Piece do
  describe '#init' do
    it 'return an instance of piece with the right type and arguments' do
      expect(Piece::init('k', [0, 0])).to equal_piece Piece::King.new([0, 0], :b)
      expect(Piece::init('q', [3, 3])).to equal_piece Piece::Queen.new([3, 3], :b)
      expect(Piece::init('r', [2, 2])).to equal_piece Piece::Rook.new([2, 2], :b)
      expect(Piece::init('B', [4, 4])).to equal_piece Piece::Bishop.new([4, 4], :w)
      expect(Piece::init('N', [0, 5])).to equal_piece Piece::Knight.new([0, 5], :w)
      expect(Piece::init('P', [6, 0])).to equal_piece Piece::Pawn.new([6, 0], :w)
    end
  end
end
