require 'game_components/pieces/basic_piece'
require 'game_components/pieces/chess_pieces/king'
require_relative '../testing_helpers.rb'

describe BasicPiece do
  subject { BasicPiece.new [3, 3], 'black' }

  describe '#initialize' do
    it { expect(subject.position).to eql([3, 3]) }
    it { expect(subject.color).to eql('black') }
  end

  describe 'private methods' do
    let(:testing_board) do
      TestingBoard.new(
        rook_modified_positions: [[3, 3]],
        king_modified_positions: [
          [3, 1], [3, 6], [1, 3], [6, 3],
          [0, 0], [1, 5], [5, 1], [6, 6]
        ]
      )
    end
    subject { testing_board[3, 3] }
    let(:horizontal_sides) { subject.send(:get_sides_of, testing_board, 'horizontal') }
    let(:vertical_sides) { subject.send(:get_sides_of, testing_board, 'vertical') }
    let(:diag_sides) { subject.send(:get_sides_of, testing_board, 'diagonal') }
    let(:anti_diag_sides) { subject.send(:get_sides_of, testing_board, 'anti_diagonal') }
    # can't test with contain_exactly since nil != EmptyCell
    let(:left_side) { [nil, Piece::King.new([3, 1], 'black'), nil] }
    let(:right_side) { [nil, nil, King.new([3, 6], 'black'), nil] }
    let(:up_side) { [nil, King.new([1, 3], 'black'), nil] }
    let(:down_side) { [nil, nil, King.new([6, 3], 'white'), nil] }
    let(:diag_up_side) {  [nil, King.new([1, 5], 'black'), nil] }
    let(:diag_down_side) { [nil, King.new([5, 1], 'white'), nil] }
    let(:anti_diag_up_side) { [nil, nil, King.new([0, 0], 'black')] }
    let(:anti_diag_down_side) { [nil, nil, King.new([6, 6], 'white'), nil] }

    describe '#get_sides_of' do
      context 'orientation = horizontal' do
        it { expect(horizontal_sides[0]).to equal_piece_array(left_side) }
        it { expect(horizontal_sides[1]).to equal_piece_array(right_side) }
      end
      context 'orientation = vertical' do
        it { expect(vertical_sides[0]).to equal_piece_array(up_side) }
        it { expect(vertical_sides[1]).to equal_piece_array(down_side) }
      end
      context 'orientation = diagonal' do
        it { expect(diag_sides[0]).to equal_piece_array(diag_up_side) }
        it { expect(diag_sides[1]).to equal_piece_array(diag_down_side) }
      end
    end
    context 'orientation = anti_diagonal' do
      it { expect(anti_diag_sides[0]).to equal_piece_array(anti_diag_up_side) }
      it { expect(anti_diag_sides[1]).to equal_piece_array(anti_diag_down_side) }
    end

    describe 'get_grouped_sides_of' do
      it "orientations = ['horizontal', 'vertical']" do
        expect(subject
          .send(:get_grouped_sides_of, testing_board, 'horizontal', 'vertical'))
          .to contain_exactly(*horizontal_sides, *vertical_sides)
      end
      it 'orientations = [diagonal, anti_diagonal]' do
        expect(subject
          .send(:get_grouped_sides_of, testing_board, 'diagonal', 'anti_diagonal'))
          .to contain_exactly(*diag_sides, *anti_diag_sides)
      end
      it 'orientations = [vertical, horizontal, diagonal, anti_diagonal]' do
        expect(subject
          .send(:get_grouped_sides_of, testing_board,
                'vertical', 'horizontal', 'diagonal', 'anti_diagonal'))
          .to contain_exactly(*horizontal_sides, *vertical_sides, *diag_sides, *anti_diag_sides)
      end
    end

    describe '#filter_side' do
      let(:filter_left_side) { subject.send(:filter_side, left_side) }
      let(:filter_up_side) { subject.send(:filter_side, up_side) }
      let(:filter_diag_down_side) { subject.send(:filter_side, diag_down_side) }
      let(:filter_anti_diag_down_side) { subject.send(:filter_side, anti_diag_down_side) }
      context 'left side' do
        it { expect(filter_left_side).to equal_piece_array([nil]) }
      end
      context 'up side' do
        it { expect(filter_up_side).to equal_piece_array([nil, nil]) }
      end

      context 'diagonal down side' do
        it { expect(filter_diag_down_side).to equal_piece_array([nil, King.new([5, 1], 'white')]) }
      end

      context 'anti diagonal down side' do
        it { expect(filter_anti_diag_down_side).to equal_piece_array([nil, nil, King.new([6, 6], 'white')]) }
      end
    end
  end
end
