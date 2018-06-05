require 'game_components/pieces/chess_pieces/rook'
require_relative '../../../testing_helper/h_board'

describe Rook, for: 'rook' do
  describe '#get_possible_moves' do
    let(:std_rook) { Rook.new [3, 3], 'black' }
    let(:std_tb) do
      in_middle(
        std_rook,
        [3, 1], [3, 6], [1, 3], [6, 3]
      )
    end
    it 'happy path' do
      expect([std_tb, std_rook])
        .to contain_exact_positions([3, 2], [3, 4], [3, 5], [2, 3], [4, 3], [5, 3], [6, 3])
    end

    let(:corner_UL_rook) { Rook.new [0, 0], 'black' }
    let(:corner_UL_tb) do
      in_corner(
        :up_left,
        corner_UL_rook,
        [0, 3], [3, 0]
      )
    end
    it 'corner up left' do
      expect([corner_UL_tb, corner_UL_rook])
        .to contain_exact_positions([0, 1], [0, 2], [1, 0], [2, 0])
    end

    let(:corner_DR_rook) { Rook.new [7, 7], 'white' }
    let(:corner_DR_tb) do
      in_corner(
        :down_right,
        corner_DR_rook,
        [5, 7], [7, 5]
      )
    end
    it 'corner down right' do
      expect([corner_DR_tb, corner_DR_rook])
        .to contain_exact_positions([7, 6], [6, 7])
    end
  end
end
