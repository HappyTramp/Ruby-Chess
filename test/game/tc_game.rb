require 'game/index'
require 'game/components/pieces/index'
require 'game/components/board'
require_relative '../test_helper/h_board'
require_relative '../test_helper/h_piece'

class Game; attr_accessor :board; end

describe Game do
  subject { Game.new Board.new '8/3p4/2k1p3/1p1q1p2/1NB1P3/PP1R1P2/8/8' }

  describe '#all_pieces_possible_moves' do
    it 'return all correct possible move of all pieces' do
      subject.all_pieces_possible_moves.each do |pm_ref|
        case pm_ref[:position]
        when [2, 2] then
          expect(pm_ref[:possible_moves])
            .to contain_exactly([1, 1], [1, 2], [2, 1], [2, 3], [3, 2])
        when [3, 3] then
          expect(pm_ref[:possible_moves])
            .to contain_exactly([2, 3], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4], [5, 3])
        when [5, 3] then
          expect(pm_ref[:possible_moves])
            .to contain_exactly([3, 3], [4, 3], [5, 2], [5, 4], [6, 3], [7, 3])
        when [4, 2] then expect(pm_ref[:possible_moves]).to contain_exactly([3, 1], [3, 3])
        when [4, 1] then
          expect(pm_ref[:possible_moves])
            .to contain_exactly([2, 0], [2, 2], [3, 3], [6, 2], [6, 0])
        when [4, 4] then expect(pm_ref[:possible_moves]).to contain_exactly([3, 3], [3, 4], [3, 5])
        end
      end
    end
  end

  describe '#pawn_promotion' do
    let(:no_promo_g) { Game.new Board.new('8/8/8/3k4/8/8/8/8') }
    it { expect(no_promo_g.pawn_promotion).to be nil }
    let(:promo_white_g) { Game.new Board.new('3P4/8/8/8/8/8/8/8') }
    it { expect(promo_white_g.pawn_promotion).to eql([0, 3]) }
    let(:promo_black_g) { Game.new Board.new('8/8/8/8/8/8/8/3p4') }
    it { expect(promo_black_g.pawn_promotion).to eql([7, 3]) }
  end

  describe '#castling' do
    let(:no_cstl_g) { Game.new Board.new('k7/8/8/3r4/8/8/8/8') }
    it 'don\'t add any move' do
      pm = no_cstl_g.board[0, 0].get_possible_moves(no_cstl_g.board)
      no_cstl_g.castling
      expect(pm).to eql(no_cstl_g.board[0, 0].get_possible_moves(no_cstl_g.board))
    end
    let(:black_lt_cstl_g) { Game.new Board.new('4k2r/8/8/8/8/8/8/8') }
    it 'add the black little castle move' do
      black_lt_cstl_g.castling
      expect(black_lt_cstl_g.board[0, 4]
        .get_possible_moves(black_lt_cstl_g.board))
        .to include([0, 6])
    end
    let(:black_lg_cstl_g) { Game.new Board.new('r3k3/8/8/8/8/8/8/8') }
    it 'add the black large castle move' do
      black_lg_cstl_g.castling
      expect(black_lg_cstl_g.board[0, 4]
        .get_possible_moves(black_lg_cstl_g.board))
        .to include([0, 2])
    end
    let(:white_lt_cstl_g) { Game.new Board.new('8/8/8/8/8/8/8/4K2R') }
    it 'add the white little castle move' do
      white_lt_cstl_g.castling
      expect(white_lt_cstl_g.board[7, 4]
        .get_possible_moves(white_lt_cstl_g.board))
        .to include([7, 6])
    end
    let(:white_lg_cstl_g) { Game.new Board.new('8/8/8/8/8/8/8/R3K3') }
    it 'add the white large castle move' do
      white_lg_cstl_g.castling
      expect(white_lg_cstl_g.board[7, 4]
        .get_possible_moves(white_lg_cstl_g.board))
        .to include([7, 2])
    end
  end
end
