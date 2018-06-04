require 'game_components/pieces/chess_pieces/knight.rb'
require_relative '../../testing_helpers.rb'

describe Knight do
  describe '#get_possible_moves' do
    let(:testing_board) do
      TestingBoard.new(
        knight_modified_positions: [[4, 3]],
        king_modified_positions: [
          [3, 1], [2, 4], [3, 5],
          [5, 5], [6, 4], [5, 1]
        ]
      )
    end
    subject { testing_board[4, 3] }
    it 'happy path centered' do
      expect(subject.get_possible_moves(testing_board))
        .to contain_exactly([2, 2], [5, 1], [6, 2], [5, 5], [6, 4])
    end

    let(:corner_up_left_tboard) do
      TestingBoard.new(
        knight_modified_positions: [[1, 1]],
        king_modified_positions: [
          [3, 0], [2, 3], [0, 3]
        ]
      )
    end
    let(:knight_test) { corner_up_left_tboard[1, 1] }
    it 'in the up left corner, shouldnt fail' do
      expect { knight_test.get_possible_moves(corner_up_left_tboard) }.to_not raise_error
      expect(knight_test.get_possible_moves(corner_up_left_tboard))
        .to contain_exactly([3, 2])
    end

  end
end
