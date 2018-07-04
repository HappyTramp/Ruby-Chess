require 'game/components/pieces/childs/rook'
require 'game/components/board'

describe Rook, for: 'rook' do
  describe '#get_possible_moves' do
    let(:std_tb) { Board.new '8/3k4/8/1k1r2k1/8/8/3K4/8' }
    it 'happy path' do
      expect([std_tb, std_tb[3, 3]])
        .to contain_exact_positions([3, 2], [3, 4], [3, 5], [2, 3], [4, 3], [5, 3], [6, 3])
    end

    let(:corner_UL_tb) { Board.new 'r2k4/8/8/k7/8/8/8/8' }
    it 'corner up left' do
      expect([corner_UL_tb, corner_UL_tb[0, 0]])
        .to contain_exact_positions([0, 1], [0, 2], [1, 0], [2, 0])
    end

    let(:corner_DR_tb) { Board.new '8/8/8/8/8/7K/8/5K1R' }
    it 'corner down right' do
      expect([corner_DR_tb, corner_DR_tb[7, 7]])
        .to contain_exact_positions([7, 6], [6, 7])
    end
  end
end
