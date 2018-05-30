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

  describe '#possibilitiesList' do
    let(:rook) { Rook.new [3, 3], 'black' }
    let(:solo_board) { TestingBoard.new(rookModifiedPositions: [[3, 3]])}
    let(:pieces_blocking_board) do
      TestingBoard.new(
        rookModifiedPositions: [[3, 3]],
        kingModifiedPositions: [[3, 1], [3, 6], [1, 3], [6, 3]]
      )
    end

    context 'alone in the middle of the board' do
      it 'return a list on the vertical and horizontal axes of the rook' do
        expected_possibilities_list =
          [3].product((0..7).to_a) + (0..7).to_a.product([3])
        expected_possibilities_list.delete([3, 3])

        expect(rook.possibilitiesList(solo_board))
        .to contain_exactly(*expected_possibilities_list)
      end
    end
    
    context 'alone, enemy blocking border cell' do
      it 'return a list of position with the enemy pieces'\
         ' and without the ally one and the cell on the borders' do
        expected_possibilities_list =
        [3].product((2..5).to_a) + (2..6).to_a.product([3])
        expected_possibilities_list.delete([3, 3])
        
        expect(rook.possibilitiesList(pieces_blocking_board))
        .to contain_exactly(*expected_possibilities_list)
      end
    end
  end
end
