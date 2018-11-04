require 'game/components/pieces/childs/king.rb'
require 'game/components/board.rb'
require_relative '../../../../test_helper/h_piece.rb'

describe King, for: 'king' do
  describe '#controlled_square' do
    let(:std_black_tb) { Board.new '8/8/3K4/3kk3/2k1K3/8/8/8' }
    it do
      expect([std_black_tb, std_black_tb[3, 3]])
        .to control_position([2, 2], [2, 4], [2, 3], [4, 2], [4, 4], [4, 3], [3, 2], [3, 4])
    end

    let(:std_white_tb) { Board.new '8/8/8/2K1K3/3K4/2kKk3/8/8' }
    it do
      expect([std_white_tb, std_white_tb[4, 3]])
        .to control_position([3, 2], [3, 4], [3, 3], [5, 2], [5, 4], [5, 3], [4, 2], [4, 4])
    end

    let(:corner_UL_tb) { Board.new 'k7/1k6/8/8/8/8/8/8' }
    it 'shouldnt fail' do
      expect { corner_UL_tb[0, 0].controlled_square(corner_UL_tb) }.to_not raise_error
      expect([corner_UL_tb, corner_UL_tb[0, 0]]).to control_position([0, 1], [1, 0], [1, 1])
    end

    let(:corner_DR_tb) { Board.new '8/8/8/8/8/8/6K1/7K' }
    it 'shouldnt fail' do
      expect { corner_DR_tb[7, 7].controlled_square(corner_DR_tb) }.to_not raise_error
      expect([corner_DR_tb, corner_DR_tb[7, 7]]).to control_position([7, 6], [6, 7], [6, 6])
    end
  end
end
