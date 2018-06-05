require 'game_components/pieces/chess_pieces/bishop.rb'
require_relative '../../../testing_helper/h_board'

describe Bishop, for: 'bishop' do
  describe '#get_possible_moves' do
    let(:std_bishop) { Bishop.new [3, 3], 'black' }
    let(:std_tb) { in_middle(std_bishop, [1, 1], [1, 5], [5, 1], [6, 6]) }
    it 'happy path' do
      expect([std_tb, std_bishop])
        .to contain_exact_positions(
          [2, 2], [2, 4], [4, 4], [5, 5], [6, 6], [4, 2], [5, 1]
        )
    end

    let(:corner_UL_bishop) { Bishop.new [0, 0], 'black' }
    let(:corner_UL_tb) { in_corner(:up_left, corner_UL_bishop, [3, 3]) }
    it 'corner up left' do
      expect([corner_UL_tb, corner_UL_bishop])
        .to contain_exact_positions([1, 1], [2, 2])
    end

    let(:corner_UR_bishop) { Bishop.new [0, 7], 'black' }
    let(:corner_UR_tb) { in_corner(:up_right, corner_UR_bishop, [3, 4]) }
    it 'corner up right' do
      expect([corner_UR_tb, corner_UR_bishop])
        .to contain_exact_positions([1, 6], [2, 5])
    end

    let(:corner_DL_bishop) { Bishop.new [7, 0], 'white' }
    let(:corner_DL_tb) { in_corner(:down_left, corner_DL_bishop, [3, 4]) }
    it 'corner down left' do
      expect([corner_DL_tb, corner_DL_bishop])
        .to contain_exact_positions([6, 1], [5, 2], [4, 3], [3, 4])
    end

    let(:corner_DR_bishop) { Bishop.new [7, 7], 'white' }
    let(:corner_DR_tboard) { in_corner(:down_right, corner_DR_bishop, [3, 3]) }
    it 'corner down right' do
      expect([corner_DR_tboard, corner_DR_bishop])
        .to contain_exact_positions([6, 6], [5, 5], [4, 4], [3, 3])
    end
  end
end
