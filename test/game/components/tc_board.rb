require 'game/components/board'
require 'game/components/pieces/index'
require_relative '../../test_helper/h_board'
require_relative '../../test_helper/h_piece'

class Board; attr_accessor :grid; end

class ECell
  def self.empty?
    true
  end
end

describe Board, for: 'board' do
  describe '#initialize' do
    let(:initial_grid) do
      [
        [
          Piece::Rook.new([0, 0], :b), Piece::Knight.new([0, 1], :b),
          Piece::Bishop.new([0, 2], :b), Piece::Queen.new([0, 3], :b),
          Piece::King.new([0, 4], :b), Piece::Bishop.new([0, 5], :b),
          Piece::Knight.new([0, 6], :b), Piece::Rook.new([0, 7], :b)
        ],
        (1..8).map.with_index { |_, i| Piece::Pawn.new([1, i], :b) },
        [ECell, ECell, ECell, ECell, ECell, ECell, ECell, ECell],
        [ECell, ECell, ECell, ECell, ECell, ECell, ECell, ECell],
        [ECell, ECell, ECell, ECell, ECell, ECell, ECell, ECell],
        [ECell, ECell, ECell, ECell, ECell, ECell, ECell, ECell],
        (1..8).map.with_index { |_, i| Piece::Pawn.new([6, i], :w) },
        [
          Piece::Rook.new([7, 0], :w), Piece::Knight.new([7, 1], :w),
          Piece::Bishop.new([7, 2], :w), Piece::Queen.new([7, 3], :w),
          Piece::King.new([7, 4], :w), Piece::Bishop.new([7, 5], :w),
          Piece::Knight.new([7, 6], :w), Piece::Rook.new([7, 7], :w)
        ]
      ]
    end
    context 'default configuration' do
      it 'create a 8x8 empty board (2D array)' do
        subject.grid.each.with_index do |row, i|
          expect(row).to equal_piece_array(initial_grid[i])
        end
      end
      it 'the rows are NOT from same instance' do
        subject.grid[0][0] = true
        expect(subject.grid[1][0]).to_not be true
      end
    end

    context 'modified pieces configuration' do
      it 'create a grid with the given positions' do
        modified_grid = Board.new('qnb1kbn1/pppppppp/8/8/8/8/PPPPPPPP/1NB1KBN1').grid
        initial_grid.map! do |row|
          row.map! { |cell| [Piece::Queen, Piece::Rook].include?(cell.class) ? ECell : cell }
        end
        initial_grid[0][0] = Piece::Queen.new [0, 0], :b

        modified_grid.each.with_index do |row, i|
          expect(row).to equal_piece_array(initial_grid[i])
        end
      end
    end
  end

  describe 'grid elements getter and setter' do
    describe '#[]' do
      context 'happy path' do
        it 'return a piece or ECell if empty' do
          expect(subject[0, 0]).to equal_piece(Piece::Rook.new([0, 0], :b))
          expect(subject[6, 5]).to equal_piece(Piece::Pawn.new([6, 5], :w))
        end
        it 'return EmptyCell if the cell is empty' do
          expect(subject[4, 0]).to be_instance_of EmptyCell
          expect(subject[3, 3]).to be_instance_of EmptyCell
        end
      end
      context 'wrong index' do
        it 'return false' do
          expect(subject[-1, 0]).to be false
          expect(subject[0, 8]).to be false
        end
      end
    end

    describe '#[]=' do
      context 'happy path' do
        it 'set the cell to the given value' do
          subject[0, 0] = nil
          expect(subject.grid[0][0]).to be_nil
          test_piece = Piece::Queen.new [6, 2], :b
          subject[6, 2] = test_piece
          expect(subject.grid[6][2]).to equal_piece(test_piece)
        end
      end
      context 'wrong index' do
        it 'doesn\'t change anything' do
          subject_copy = subject.clone
          subject[-1, 0] = nil
          expect(subject_copy.grid).to eql subject.grid
          subject[0, 8] = nil
          expect(subject_copy.grid).to eql subject.grid
        end
      end
    end
  end

  describe '#get_row' do
    it 'return the correct row at the given index' do
      expect(subject.get_row(0)).to eql(subject.grid[0])
    end
  end
  describe '#get_column' do
    it 'return the correct col at the given index' do
      expect(subject.get_column(0)).to eql(subject.grid.transpose[0])
    end
  end

  describe '#get_diagonal' do
    let(:diag33) do
      [Piece::Pawn.new([6, 0], :w),
       ECell, ECell, ECell, ECell,
       Piece::Pawn.new([1, 5], :b), Piece::Knight.new([0, 6], :b)]
    end
    let(:diag52) do
      [Piece::Rook.new([7, 0], :w), Piece::Pawn.new([6, 1], :w),
       ECell, ECell, ECell, ECell,
       Piece::Pawn.new([1, 6], :b), Piece::Rook.new([0, 7], :b)]
    end
    let(:a_diag06) do
      [Piece::Knight.new([0, 6], :b),
       Piece::Pawn.new([1, 7], :b)]
    end
    let(:a_diag45) do
      [Piece::Knight.new([0, 1], :b), Piece::Pawn.new([1, 2], :b),
       ECell, ECell, ECell, ECell,
       Piece::Pawn.new([6, 7], :w)]
    end
    context 'diagonal (with arg anti: false)' do
      it { expect(subject.get_diagonal(3, 3)).to equal_piece_array(diag33) }
      it { expect(subject.get_diagonal(5, 2)).to equal_piece_array(diag52) }
    end
    context 'anti diagonal (with arg anti: true)' do
      it { expect(subject.get_diagonal(0, 6, anti: true)).to equal_piece_array(a_diag06) }
      it { expect(subject.get_diagonal(4, 5, anti: true)).to equal_piece_array(a_diag45) }
    end
  end

  describe 'private methods' do
    describe '#index_in_border?' do
      context 'out of borders indexes' do
        it { expect(subject.send(:index_in_border?, -1, 0)).to be false }
        it { expect(subject.send(:index_in_border?, 0, -1)).to be false }
        it { expect(subject.send(:index_in_border?, 8, 0)).to be false }
        it { expect(subject.send(:index_in_border?, 0, 8)).to be false }
      end

      context 'in borders indexes' do
        it { expect(subject.send(:index_in_border?, 0, 0)).to be true }
        it { expect(subject.send(:index_in_border?, 7, 0)).to be true }
        it { expect(subject.send(:index_in_border?, 0, 7)).to be true }
      end
    end
  end

  describe '#to_s' do
    subject = Board.new
    it 'initial configuration' do
      expect(subject.to_s).to eql(
        "     a   b   c   d   e   f   g   h  \n"\
        "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
        " 1 │ ♜ │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 2 │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 3 │   │   │   │   │   │   │   │   │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 4 │   │   │   │   │   │   │   │   │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 5 │   │   │   │   │   │   │   │   │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 6 │   │   │   │   │   │   │   │   │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 7 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
        "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
        " 8 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
        "   └───┴───┴───┴───┴───┴───┴───┴───┘"
      )
    end
    context 'some pieces moved' do
      it 'return an accurate stringified grid according to the changes' do
        subject[0, 0] = EmptyCell.new [0, 0]
        subject[1, 1] = Piece::Rook.new [1, 1], :w
        subject[3, 3] = Piece::King.new [3, 3], :b
        expect(subject.to_s).to eql(
          "     a   b   c   d   e   f   g   h  \n"\
          "   ┌───┬───┬───┬───┬───┬───┬───┬───┐\n"\
          " 1 │   │ ♞ │ ♝ │ ♛ │ ♚ │ ♝ │ ♞ │ ♜ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 2 │ ♟ │ ♖ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │ ♟ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 3 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 4 │   │   │   │ ♚ │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 5 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 6 │   │   │   │   │   │   │   │   │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 7 │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │ ♙ │\n"\
          "   ├───┼───┼───┼───┼───┼───┼───┼───┤\n"\
          " 8 │ ♖ │ ♘ │ ♗ │ ♕ │ ♔ │ ♗ │ ♘ │ ♖ │\n"\
          "   └───┴───┴───┴───┴───┴───┴───┴───┘"
        )
      end
    end
  end
end
