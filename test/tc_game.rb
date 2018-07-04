require 'game'
require 'game_components/pieces/pieces'
require 'game_components/board'
require_relative './test_helper/h_board'
require_relative './test_helper/h_piece'

class Game; attr_accessor :board; end

describe Game do
  let(:game_tb) { Board.new '8/3p4/2k1p3/1p1q1p2/1NB1P3/PP1R1P2/8/8' }
  subject { Game.new game_tb }

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

  # describe '#find_pawn_promotion' do
  #   let(:no_promo_game) { Game.new Board.new(''Piece::King.new([3, 3], 'black')) }
  #   it { expect(no_promo_game.find_pawn_promotion).to be nil }
  #   let(:promo_white_game) { Game.new Board.new(''Piece::Pawn.new([0, 4], 'white')) }
  #   it { expect(promo_white_game.find_pawn_promotion).to eql([0, 4]) }
  #   let(:promo_black_game) { Game.new Board.new(''Piece::Pawn.new([7, 3], 'black')) }
  #   it { expect(promo_black_game.find_pawn_promotion).to eql([7, 3]) }
  # end

  # describe '#add_possible_castling' do
  #   let(:no_castling_game) { Game.new(tb_constructor(Piece::Rook.new([3, 3], 'black'), [0, 3])) }
  #   it 'shouldnt add any possible move to the King' do
  #     pm = no_castling_game.board[0, 3].get_possible_moves(no_castling_game.board)
  #     no_castling_game.add_possible_castling
  #     expect(pm).to eql(no_castling_game.board[0, 3].get_possible_moves(no_castling_game.board))
  #   end
  #   let(:black_little_castling_game) { Game.new tb_constructor(Piece::Rook.new([0, 7], 'black'), [0, 4]) }
  #   it do
  #     pm = black_little_castling_game.board[0, 4].get_possible_moves(black_little_castling_game.board)
  #     black_little_castling_game.add_possible_castling
  #     expect(pm).to include([0, 2])
  #   end
  #   let(:black_big_castling_game) { Game.new tb_constructor(Piece::Rook.new([0, 0], 'black'), [0, 4]) }
  #   it do
  #     pm = black_big_castling_game.board[0, 4].get_possible_moves(black_big_castling_game.board)
  #     black_big_castling_game.add_possible_castling
  #     expect(pm).to include([0, 6])
  #   end
  #   let(:white_little_castling_game) { Game.new tb_constructor(Piece::Rook.new([7, 7], 'white'), [7, 4]) }
  #   it do
  #     pm = white_little_castling_game.board[7, 4].get_possible_moves(white_little_castling_game.board)
  #     white_little_castling_game.add_possible_castling
  #     expect(pm).to include([7, 2])
  #   end
  #   let(:white_big_castling_game) { Game.new tb_constructor(Piece::Rook.new([7, 0], 'white'), [7, 4]) }
  #   it do
  #     pm = white_big_castling_game.board[7, 4].get_possible_moves(white_big_castling_game.board)
  #     white_big_castling_game.add_possible_castling
  #     expect(pm).to include([7, 6])
  #   end
  # end
end
