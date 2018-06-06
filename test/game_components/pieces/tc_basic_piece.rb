require 'game_components/pieces/basic_piece'
require 'game_components/pieces/chess_pieces/king'
require_relative '../../testing_helper/h_board'
require_relative '../../testing_helper/h_piece'

describe BasicPiece, for: 'basicpiece' do
  subject { BasicPiece.new [3, 3], 'black' }

  describe '#initialize' do
    it { expect(subject.position).to eql([3, 3]) }
    it { expect(subject.color).to eql('black') }
  end

  describe 'private methods' do
    let(:tb) do
      TestingBoard.new(
        rook_modified_positions: [[3, 3]],
        king_modified_positions: [
          [3, 1], [3, 6], [1, 3], [6, 3],
          [0, 0], [1, 5], [5, 1], [6, 6]
        ]
      )
    end
    subject { tb[3, 3] }
    let(:horz_sides)   { subject.send(:get_sides_of, tb, :horizontal) }
    let(:vert_sides)   { subject.send(:get_sides_of, tb, :vertical) }
    let(:diag_sides)   { subject.send(:get_sides_of, tb, :diagonal) }
    let(:a_diag_sides) { subject.send(:get_sides_of, tb, :anti_diagonal) }
    # can't test with contain_exactly since nil != EmptyCell
    let(:horz_1s_side)   { [nil, Piece::King.new([3, 1], 'black'), nil] }
    let(:horz_2n_side)   { [nil, nil, King.new([3, 6], 'black'), nil] }
    let(:vert_1s_side)   { [nil, King.new([1, 3], 'black'), nil] }
    let(:vert_2n_side)   { [nil, nil, King.new([6, 3], 'white'), nil] }
    let(:diag_1s_side)   { [nil, King.new([5, 1], 'white'), nil] }
    let(:diag_2n_side)   { [nil, King.new([1, 5], 'black'), nil] }
    let(:a_diag_1s_side) { [nil, nil, King.new([0, 0], 'black')] }
    let(:a_diag_2n_side) { [nil, nil, King.new([6, 6], 'white'), nil] }

    describe '#get_sides_of', getsides: true do
      context 'orientation = horizontal' do
        it { expect(horz_sides[0]).to equal_piece_array(horz_1s_side) }
        it { expect(horz_sides[1]).to equal_piece_array(horz_2n_side) }
      end
      context 'orientation = vertical' do
        it { expect(vert_sides[0]).to equal_piece_array(vert_1s_side) }
        it { expect(vert_sides[1]).to equal_piece_array(vert_2n_side) }
      end
      context 'orientation = diagonal' do
        it { expect(diag_sides[0]).to equal_piece_array(diag_1s_side) }
        it { expect(diag_sides[1]).to equal_piece_array(diag_2n_side) }
      end
      context 'orientation = anti_diagonal' do
        it { expect(a_diag_sides[0]).to equal_piece_array(a_diag_1s_side) }
        it { expect(a_diag_sides[1]).to equal_piece_array(a_diag_2n_side) }
      end
    end

    describe 'get_grouped_sides_of' do
      it "orientations = ['horizontal', 'vertical']" do
        expect(subject
          .send(:get_grouped_sides_of, tb, :horizontal, :vertical))
          .to contain_exactly(*horz_sides, *vert_sides)
      end
      it 'orientations = [diagonal, anti_diagonal]' do
        expect(subject
          .send(:get_grouped_sides_of, tb, :diagonal, :anti_diagonal))
          .to contain_exactly(*diag_sides, *a_diag_sides)
      end
      it 'orientations = [vertical, horizontal, diagonal, anti_diagonal]' do
        expect(subject
          .send(:get_grouped_sides_of, tb,
                :vertical, :horizontal, :diagonal, :anti_diagonal))
          .to contain_exactly(*horz_sides, *vert_sides, *diag_sides, *a_diag_sides)
      end
    end

    describe '#filter_side' do
      let(:flt_horz_1s_side)   { subject.send(:filter_side, horz_1s_side) }
      let(:flt_vert_2n_side)   { subject.send(:filter_side, vert_2n_side) }
      let(:flt_diag_1s_side)   { subject.send(:filter_side, diag_1s_side) }
      let(:flt_a_diag_2n_side) { subject.send(:filter_side, a_diag_2n_side) }
      it('left side') { expect(flt_horz_1s_side).to equal_piece_array([nil]) }
      it('up side') { expect(flt_vert_2n_side).to equal_piece_array([nil, nil]) }
      it 'diagonal down side' do
        expect(flt_diag_1s_side).to equal_piece_array([nil, King.new([5, 1], 'white')])
      end
      it'anti diagonal down side' do
        expect(flt_a_diag_2n_side).to equal_piece_array([nil, nil, King.new([6, 6], 'white')])
      end
    end

    describe '#valid_cell?' do
      context 'the cell is nil or enemy color' do
        it { expect(subject.send(:valid_cell?, King.new([0, 0], 'white'))).to be true }
        it { expect(subject.send(:valid_cell?, nil)).to be true }
      end
      context 'the cell is the same color or false' do
        it { expect(subject.send(:valid_cell?, King.new([0, 0], 'black'))).to be false }
        it { expect(subject.send(:valid_cell?, false)).to be nil }
      end
    end

    describe '#get_cell_type' do
      it { expect(subject.send(:get_cell_type, EmptyCell.new([0, 0]))).to be :empty }
      it { expect(subject.send(:get_cell_type, BasicPiece.new([0, 0], 'black'))).to be :ally }
      it { expect(subject.send(:get_cell_type, BasicPiece.new([0, 0], 'white'))).to be :enemy }
    end
  end
end
