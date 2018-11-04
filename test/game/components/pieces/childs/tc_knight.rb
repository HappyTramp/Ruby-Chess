require 'game/components/pieces/childs/knight.rb'
require 'game/components/board'
require_relative '../../../../test_helper/h_piece'

describe Knight, for: 'knight' do
  describe '#controlled_square' do
    let(:std_tb) { Board.new '8/4k3/1k3K2/3n4/5k2/8/8/8' }
    it 'happy path' do
      expect([std_tb, std_tb[3, 3]])
        .to contain_exact_positions([2, 5], [4, 1], [1, 2], [5, 2], [5, 4])
    end

    let(:corner_UL_tb) { Board.new 'n7/8/1k6/8/8/8/8/8' }
    it 'corner up left, shouldnt fail' do
      expect { corner_UL_tb[0, 0].controlled_square(corner_UL_tb) }.to_not raise_error
      expect([corner_UL_tb, corner_UL_tb[0, 0]])
        .to contain_exact_positions([1, 2])
    end

    let(:corner_DR_tb) { Board.new '8/8/8/8/8/6K1/8/7N' }
    it 'corner down right, shouldnt fail' do
      expect { corner_DR_tb[7, 7].controlled_square(corner_DR_tb) }.to_not raise_error
      expect([corner_DR_tb, corner_DR_tb[7, 7]])
        .to contain_exact_positions([6, 5])
    end
  end
end
