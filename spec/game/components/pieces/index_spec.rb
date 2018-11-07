require 'game/components/pieces/index'
require_relative '../../../test_helper/h_piece'

describe Pieces, for: 'pieces' do
  describe '.init' do
    it 'return an instance of piece with a letter and a position', :aggregate_failures do
      expect(described_class::init('k', [0, 0])).to eq Pieces::King.new([0, 0], :b)
      expect(described_class::init('q', [3, 3])).to eq Pieces::Queen.new([3, 3], :b)
      expect(described_class::init('B', [4, 4])).to eq Pieces::Bishop.new([4, 4], :w)
      expect(described_class::init('N', [0, 5])).to eq Pieces::Knight.new([0, 5], :w)
    end
  end
end
