require 'game_components/pieces/chess_pieces/rook'
require_relative '../../testing_helpers'

describe Rook do
  describe 'representation' do
    context 'black color' do
      it 'return a correct repr' do
        expect(Rook.new([0, 0], 'black').to_s).to eql('♜')
      end
    end

    context 'white color' do
      it 'return a correct repr' do
        expect(Rook.new([0, 0], 'white').to_s).to eql('♖')
      end
    end
  end

  describe '#get_possible_moves' do
    let(:rook) { Rook.new [3, 3], 'black' }
    let(:solo_board) { TestingBoard.new(rook_modified_positions: [[3, 3]]) }
    let(:pieces_blocking_board) do
      TestingBoard.new(
        rook_modified_positions: [[3, 3]],
        king_modified_positions: [[3, 1], [3, 6], [1, 3], [6, 3]]
      )
    end
    let(:corner_up_left_rook) { Rook.new [0, 0], 'black' }
    let(:corner_up_left_board) do
      TestingBoard.new(
        rook_modified_positions: [[0, 0]],
        king_modified_positions: [[0, 3], [3, 0]]
      )
    end
    let(:corner_down_right_rook) { Rook.new [7, 7], 'white' }
    let(:corner_down_right_board) do
      TestingBoard.new(
        rook_modified_positions: [[7, 7]],
        king_modified_positions: [[7, 5], [5, 7]]
      )
    end

    context 'alone in the middle of the board' do
      it 'return a list on the vertical and horizontal axes of the rook' do
        expected_possibilities_list =
          [3].product((0..7).to_a) + (0..7).to_a.product([3])
        expected_possibilities_list.delete([3, 3])

        expect(rook.get_possible_moves(solo_board))
          .to contain_exactly(*expected_possibilities_list)
      end
    end

    context 'pieces blocking border cells' do
      it 'return a list of position with the enemy pieces'\
         ' and without the ally one and the cell on the borders' do
        expected_possibilities_list =
          [3].product((2..5).to_a) + (2..6).to_a.product([3])
        expected_possibilities_list.delete([3, 3])

        expect(rook.get_possible_moves(pieces_blocking_board))
          .to contain_exactly(*expected_possibilities_list)
      end
    end

    context 'in the up left corner, pieces blocking' do
      it 'not fail because of the boarder' do
        expect(corner_up_left_rook.get_possible_moves(corner_up_left_board))
          .to contain_exactly([0, 1], [0, 2], [1, 0], [2, 0])
      end
    end

    context 'in the down right corner, pieces blocking' do
      it 'not fail because of the boarder' do
        expect(corner_down_right_rook.get_possible_moves(corner_down_right_board))
          .to contain_exactly([7, 6], [6, 7])
      end
    end
  end
end
