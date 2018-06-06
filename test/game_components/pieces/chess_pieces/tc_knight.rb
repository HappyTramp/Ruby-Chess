require 'game_components/pieces/chess_pieces/knight.rb'
require_relative '../../../testing_helper/h_board'
require_relative '../../../testing_helper/h_piece'

describe Knight, for: 'knight' do
  describe '#get_possible_moves' do
    let(:std_knight) { Knight.new [3, 3], 'black' }
    let(:std_tb) do
      tb_constructor(
        std_knight,
        [2, 1], [1, 4], [2, 5], [4, 5], [5, 4], [4, 1]
      )
    end
    it 'happy path' do
      expect([std_tb, std_knight])
        .to contain_exact_positions([1, 2], [4, 1], [5, 2], [4, 5], [5, 4])
    end

    let(:corner_UL_knight) { Knight.new [0, 0], 'black' }
    let(:corner_UL_tb) { in_corner(:up_left, corner_UL_knight, [2, 1]) }
    it 'corner up left, shouldnt fail' do
      expect { corner_UL_knight.get_possible_moves(corner_UL_tb) }.to_not raise_error
      expect([corner_UL_tb, corner_UL_knight])
        .to contain_exact_positions([1, 2])
    end

    let(:corner_DR_knight) { Knight.new [7, 7], 'white' }
    let(:corner_DR_tb) { in_corner(:down_right, corner_DR_knight, [5, 6]) }
    it 'corner down right, shouldnt fail' do
      expect { corner_DR_knight.get_possible_moves(corner_DR_tb) }.to_not raise_error
      expect([corner_DR_tb, corner_DR_knight])
        .to contain_exact_positions([6, 5])
    end
  end
end
