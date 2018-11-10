require 'game/components/pieces/basic_piece'
require 'game/components/pieces/childs/king'
require 'game/components/pieces/pieces'
require 'game/components/board'
require_relative '../../../test_helper/h_board'
require_relative '../../../test_helper/h_piece'
require_relative '../../../test_helper/shortcut'

class ESquare
  def self.empty?
    true
  end
end

describe BasicPiece, for: 'basic_piece' do
  subject(:b_piece) { BasicPiece.new [3, 3], :b }

  describe '#initialize' do
    it { expect(b_piece.position).to eql([3, 3]) }
    it { expect(b_piece.color).to be(:b) }
  end

  describe '#==' do
    let(:compared_piece) { sc_piece(:R00) }

    it { expect(compared_piece == sc_piece(:R00)).to be true }
    it { expect(compared_piece == sc_piece(:R11)).to be false }
    it { expect(compared_piece == sc_piece(:r00)).to be false }
    it { expect(compared_piece == sc_piece(:K00)).to be false }
  end

  describe '#possible_move' do
    let(:possible_move_tb) { Board.new '8/8/8/3q4/1P1R1r2/3B4/8/8' }

    it 'filter out ally of the controlled square' do
      expect([possible_move_tb, possible_move_tb[4, 3]])
        .to possible_move_position([4, 2], [4, 4], [4, 5], [3, 3])
    end
  end

  describe '#sides / #grouped_sides' do
    subject(:b_piece) { tb[3, 3] }

    let(:tb) { Board.new 'k7/3k1k2/8/1k1r2k1/8/1K6/3K2K1/8' }
    let(:hor_sides)   { b_piece.send(:sides, tb, :horizontal)    }
    let(:ver_sides)   { b_piece.send(:sides, tb, :vertical)      }
    let(:dia_sides)   { b_piece.send(:sides, tb, :diagonal)      }
    let(:a_dia_sides) { b_piece.send(:sides, tb, :anti_diagonal) }
    let(:grp_hor_ver_sides) { b_piece.send(:grouped_sides, tb, :horizontal, :vertical)    }
    let(:grp_dia_adi_sides) { b_piece.send(:grouped_sides, tb, :diagonal, :anti_diagonal) }
    let(:grd_all_sides) do
      b_piece.send(:grouped_sides, tb, :vertical, :horizontal, :diagonal, :anti_diagonal)
    end
    let(:hor_side_1)   { [ESquare, King.new([3, 1], :b), ESquare]          }
    let(:hor_side_2)   { [ESquare, ESquare, King.new([3, 6], :b), ESquare] }
    let(:ver_side_1)   { [ESquare, King.new([1, 3], :b), ESquare]          }
    let(:ver_side_2)   { [ESquare, ESquare, King.new([6, 3], :w), ESquare] }
    let(:dia_side_1)   { [ESquare, King.new([5, 1], :w), ESquare]          }
    let(:dia_side_2)   { [ESquare, King.new([1, 5], :b), ESquare]          }
    let(:a_dia_side_1) { [ESquare, ESquare, King.new([0, 0], :b)]          }
    let(:a_dia_side_2) { [ESquare, ESquare, King.new([6, 6], :w), ESquare] }

    context 'when orientation is horizontal' do
      it { expect(hor_sides[0]).to equal_piece_array(hor_side_1) }
      it { expect(hor_sides[1]).to equal_piece_array(hor_side_2) }
    end

    context 'when orientation is vertical' do
      it { expect(ver_sides[0]).to equal_piece_array(ver_side_1) }
      it { expect(ver_sides[1]).to equal_piece_array(ver_side_2) }
    end

    context 'when orientation is diaonal' do
      it { expect(dia_sides[0]).to equal_piece_array(dia_side_1) }
      it { expect(dia_sides[1]).to equal_piece_array(dia_side_2) }
    end

    context 'when orientation is anti diagonal' do
      it { expect(a_dia_sides[0]).to equal_piece_array(a_dia_side_1) }
      it { expect(a_dia_sides[1]).to equal_piece_array(a_dia_side_2) }
    end

    it 'orientations are horizontal and verical' do
      expect(grp_hor_ver_sides).to contain_exactly(*hor_sides, *ver_sides)
    end
    it 'orientations are diagonal and anti diagonal' do
      expect(grp_dia_adi_sides).to contain_exactly(*dia_sides, *a_dia_sides)
    end
    it 'orientations are verical, horizontal, diagonal and anti_diagonal' do
      expect(grd_all_sides).to contain_exactly(*hor_sides, *ver_sides, *dia_sides, *a_dia_sides)
    end
  end

  describe '#filter_accessibility' do
    let(:filter_acc_ally)  { b_piece.send(:filter_accessibility, [ESquare, King.new([0, 0], :b), ESquare]) }
    let(:filter_acc_enemy) { b_piece.send(:filter_accessibility, [ESquare, King.new([0, 0], :w), ESquare]) }

    it { expect(filter_acc_ally).to equal_piece_array([ESquare, King.new([0, 0], :b)]) }
    it { expect(filter_acc_enemy).to equal_piece_array([ESquare, King.new([0, 0], :w)]) }
  end

  describe '#square_type' do
    it { expect(b_piece.send(:square_type, EmptySquare.new([0, 0]))).to be :empty }
    it { expect(b_piece.send(:square_type, BasicPiece.new([0, 0], :b))).to be :ally }
    it { expect(b_piece.send(:square_type, BasicPiece.new([0, 0], :w))).to be :enemy }
  end
end
