require 'game_components/pieces/chess_pieces/queen.rb'
require_relative '../../../testing_helper/h_board'

describe Queen, for: 'queen' do
  describe '#get_possible_moves' do
    let(:std_queen) { Queen.new [3, 3], 'black' }
    let(:std_tb) do
      in_middle(
        std_queen,
        [1, 1], [1, 3], [1, 5], [3, 6],
        [6, 6], [6, 3], [5, 1], [3, 1]
      )
    end
    it 'happy path' do
      expect(std_queen.get_possible_moves(std_tb))
        .to contain_exactly(
          [2, 2], [2, 3], [2, 4], [3, 2], [3, 4],
          [3, 5], [4, 2], [4, 3], [4, 4], [5, 1],
          [5, 3], [5, 5], [6, 3], [6, 6]
        )
    end

    let(:corner_UL_queen) { Queen.new [0, 0], 'black' }
    let(:corner_UL_tb) do
      in_corner(
        :up_left,
        corner_UL_queen,
        [2, 0], [0, 2], [3, 3]
      )
    end
    it 'corner up left' do
      expect([corner_UL_tb, corner_UL_queen])
        .to contain_exact_positions([0, 1], [1, 0], [1, 1], [2, 2])
    end

    let(:corner_UR_queen) { Queen.new [0, 7], 'black' }
    let(:corner_UR_tb) do
      in_corner(
        :up_right,
        corner_UR_queen,
        [0, 4], [3, 7], [3, 4]
      )
    end
    it 'corner up right' do
      expect([corner_UR_tb, corner_UR_queen])
        .to contain_exact_positions([0, 5], [0, 6], [1, 7], [2, 7], [1, 6], [2, 5])
    end

    let(:corner_DL_queen) { Queen.new [7, 0], 'white' }
    let(:corner_DL_tb) do
      in_corner(
        :down_left,
        corner_DL_queen,
        [5, 0], [3, 4], [7, 2]
      )
    end
    it 'corner down left' do
      expect([corner_DL_tb, corner_DL_queen])
        .to contain_exact_positions([6, 0], [7, 1], [6, 1], [5, 2], [4, 3], [3, 4])
    end

    let(:corner_DR_queen) { Queen.new [7, 7], 'white' }
    let(:corner_DR_tb) do
      in_corner(
        :down_right,
        corner_DR_queen,
        [3, 3], [5, 7], [7, 4]
      )
    end
    it 'corner down right' do
      expect([corner_DR_tb, corner_DR_queen])
        .to contain_exact_positions([7, 6], [7, 5], [6, 7], [6, 6], [5, 5], [4, 4], [3, 3])
    end
  end
end
