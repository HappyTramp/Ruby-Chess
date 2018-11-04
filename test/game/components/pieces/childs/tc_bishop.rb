require 'game/components/pieces/childs/bishop'
require 'game/components/board'
require_relative '../../../../test_helper/h_piece'

describe Bishop, for: 'bishop' do
  describe '#controlled_square' do
    let(:std_tb) { Board.new '8/1k3k2/8/3b4/8/1K6/6K1/8' }
    it 'happy path' do
      expect([std_tb, std_tb[3, 3]])
        .to control_position(
          [4, 2], [5, 1], [2, 4], [1, 5], [2, 2], [1, 1], [4, 4], [5, 5], [6, 6]
        )
    end

    let(:corner_UL_tb) { Board.new 'b7/8/8/3k4/8/8/8/8' }
    it 'corner up left' do
      expect([corner_UL_tb, corner_UL_tb[0, 0]])
        .to control_position([1, 1], [2, 2], [3, 3])
    end

    let(:corner_UR_tb) { Board.new '7b/8/8/4k3/8/8/8/8' }
    it 'corner up right' do
      expect([corner_UR_tb, corner_UR_tb[0, 7]])
        .to control_position([1, 6], [2, 5], [3, 4])
    end

    let(:corner_DL_tb) { Board.new '8/8/8/4k3/8/8/8/B7' }
    it 'corner down left' do
      expect([corner_DL_tb, corner_DL_tb[7, 0]])
        .to control_position([6, 1], [5, 2], [4, 3], [3, 4])
    end

    let(:corner_DR_tb) { Board.new '8/8/8/3k4/8/8/8/7B' }
    it 'corner down right' do
      expect([corner_DR_tb, corner_DR_tb[7, 7]])
        .to control_position([6, 6], [5, 5], [4, 4], [3, 3])
    end
  end
end
