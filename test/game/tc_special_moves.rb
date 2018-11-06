require 'game/index'
require 'game/special_moves'
require 'game/components/pieces/index'
require_relative '../test_helper/h_piece'

class Game; attr_accessor :history, :board; end


describe VerifySpecialMoves, for: 'verify_special_moves' do
  describe '#can_pawn_promotion?' do
    let(:no_promo_g) { Game.new Board.new '8/8/8/3k4/8/8/8/8' }
    it { expect(no_promo_g.can_pawn_promotion?).to be false }
    let(:promo_white_g) { Game.new Board.new '3P4/8/8/8/8/8/8/8' }
    it { expect(promo_white_g.can_pawn_promotion?).to eql([0, 3]) }
    let(:promo_black_g) { Game.new Board.new '8/8/8/8/8/8/8/3p4' }
    it { expect(promo_black_g.can_pawn_promotion?).to eql([7, 3]) }
  end

  describe '#can_castle?' do
    let(:in_check_white_g) { Game.new Board.new '8/8/8/8/4q3/8/8/R3K2R' }
    let(:in_check_black_g) { Game.new Board.new 'r3k2r/8/8/4Q3/8/8/8/8' }
    let(:cast_controlled_white_g) { Game.new Board.new '8/8/8/8/3r4/8/6p1/R3K2R' }
    let(:cast_controlled_black_g) { Game.new Board.new 'r3k2r/8/6N1/5B2/8/8/8/8' }
    let(:piece_between_white_g) { Game.new Board.new '8/8/8/8/8/8/8/RN2KB1R' }
    let(:piece_between_black_g) { Game.new Board.new 'r2qk1nr/8/8/8/8/8/8/8' }
    let(:king_moved_white_g) { Game.new Board.new '8/8/8/8/8/8/8/R3K2R' }
    let(:king_moved_black_g) { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8' }
    let(:king_rook_moved_white_g) { Game.new Board.new '8/8/8/8/8/8/8/R3K2R' }
    let(:queen_rook_moved_white_g) { Game.new Board.new '8/8/8/8/8/8/8/R3K2R' }
    let(:king_rook_moved_black_g) { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8' }
    let(:queen_rook_moved_black_g) { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8' }
    let(:right_condition_white_g) { Game.new Board.new '8/8/8/8/8/8/8/R3K2R' }
    let(:right_condition_black_g) { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8' }
    let(:no_castle) { {short: false, long: false} }
    it 'false if king in check' do
      expect(in_check_white_g.can_castle?(:w)).to eq no_castle
      expect(in_check_black_g.can_castle?(:b)).to eq no_castle
    end
    it 'false if castling square are controlled by the enemy' do
      expect(cast_controlled_white_g.can_castle?(:w)).to eq no_castle
      expect(cast_controlled_black_g.can_castle?(:b)).to eq no_castle
    end
    it 'false if piece between the king and rook' do
      expect(piece_between_white_g.can_castle?(:w)).to eq no_castle
      expect(piece_between_black_g.can_castle?(:b)).to eq no_castle
    end
    it 'false if king as moved before' do
      king_moved_white_g.history.add_entry({piece: Pieces::init(:K, [7, 4]), from: [6, 4], to: [7, 4]})
      king_moved_black_g.history.add_entry({piece: Pieces::init(:k, [0, 4]), from: [1, 4], to: [0, 4]})
      expect(king_moved_white_g.can_castle?(:w)).to eq no_castle
      expect(king_moved_black_g.can_castle?(:b)).to eq no_castle
    end
    it 'false short if king rook as moved before' do
      king_rook_moved_white_g.history.add_entry({piece: Pieces::init(:R, [6, 7]), from: [7, 7], to: [6, 7]})
      king_rook_moved_black_g.history.add_entry({piece: Pieces::init(:r, [1, 7]), from: [0, 7], to: [1, 7]})
      expect(king_rook_moved_white_g.can_castle?(:w)).to eq({short: false, long: true})
      expect(king_rook_moved_black_g.can_castle?(:b)).to eq({short: false, long: true})
    end
    it 'false long if queen rook as moved before' do
      queen_rook_moved_white_g.history.add_entry({piece: Pieces::init(:R, [6, 0]), from: [7, 0], to: [6, 0]})
      queen_rook_moved_black_g.history.add_entry({piece: Pieces::init(:r, [1, 0]), from: [0, 0], to: [1, 0]})
      expect(queen_rook_moved_white_g.can_castle?(:w)).to eq({short: true, long: false})
      expect(queen_rook_moved_black_g.can_castle?(:b)).to eq({short: true, long: false})
    end
    it 'true if all condition are right' do
      expect(right_condition_white_g.can_castle?(:w)).to eq({short: true, long: true})
      expect(right_condition_black_g.can_castle?(:b)).to eq({short: true, long: true})
    end
  end

  describe '#can_en_passant?' do
    let(:white_no_en_passant_g) { Game.new Board.new '8/8/8/4Pp2/8/8/8/8' }
    let(:black_no_en_passant_g) { Game.new Board.new '8/8/8/8/1p1P4/8/8/8' }
    let(:white_en_passant_g) { Game.new Board.new '8/8/8/1pP5/8/8/8/8' }
    let(:black_en_passant_g) { Game.new Board.new '8/8/8/8/3Pp3/8/8/8' }
    let(:white_en_passant_edge_case_g) { Game.new Board.new '8/8/8/2PpP3/8/8/8/8' }
    it 'false if there is no en passant move available' do
      expect(white_no_en_passant_g.can_en_passant?(:w)).to be false
      expect(black_no_en_passant_g.can_en_passant?(:b)).to be false
    end
    it 'en passant move available -> list of dict with all info to execute it' do
      white_en_passant_g.history.add_entry({piece: Pieces::init(:p, [3, 1]), from: [1, 1], to: [3, 1]})
      black_en_passant_g.history.add_entry({piece: Pieces::init(:P, [4, 3]), from: [6, 3], to: [4, 3]})
      expect(white_en_passant_g.can_en_passant?(:w)).to eq([{from: [3, 2], to: [2, 1], capture: [3, 1]}])
      expect(black_en_passant_g.can_en_passant?(:b)).to eq([{from: [4, 4], to: [5, 3], capture: [4, 3]}])
    end
    it 'edge case with 2 pawn wich can en passant' do
      white_en_passant_edge_case_g.history.add_entry({piece: Pieces::init(:p, [3, 3]), from: [1, 3], to: [3, 3]})
      expect(white_en_passant_edge_case_g.can_en_passant?(:w)).to eq([
        {from: [3, 2], to: [2, 3], capture: [3, 3]}, 
        {from: [3, 4], to: [2, 3], capture: [3, 3]}
      ])
    end
  end
end

describe ExecuteSpecialMoves, for: 'execute_special_moves' do
  describe '#exec_pawn_promotion' do
    let(:white_promo_g) { Game.new Board.new '2P5/8/8/8/8/8/8/8' }
    let(:black_promo_g) { Game.new Board.new '8/8/8/8/8/8/8/p7' }
    it 'replace the pawn with the chosen piece' do
      white_promo_g.exec_pawn_promotion(white_promo_g.can_pawn_promotion?, :Q)
      black_promo_g.exec_pawn_promotion(black_promo_g.can_pawn_promotion?, :r)
      expect(white_promo_g.board[0, 2]).to equal_piece(Pieces::init(:Q, [0, 2]))
      expect(black_promo_g.board[7, 0]).to equal_piece(Pieces::init(:r, [7, 0]))
    end
  end

  describe '#exec_castle' do
    let(:white_short_castle_g) { Game.new Board.new '8/8/8/8/8/8/8/4K2R' }
    let(:black_short_castle_g) { Game.new Board.new '4k2r/8/8/8/8/8/8/8' }
    let(:white_long_castle_g) { Game.new Board.new '8/8/8/8/8/8/8/R3K3' }
    let(:black_long_castle_g) { Game.new Board.new 'r3k3/8/8/8/8/8/8/8' }
    it 'put the king and rook at the right position after castle' do
      white_short_castle_g.exec_castle(:w, :short)
      black_short_castle_g.exec_castle(:b, :short)
      white_long_castle_g.exec_castle(:w, :long)
      black_long_castle_g.exec_castle(:b, :long)
      expect(white_short_castle_g.board[7, 6]).to equal_piece(Pieces::init(:K, [7, 6]))
      expect(white_short_castle_g.board[7, 5]).to equal_piece(Pieces::init(:R, [7, 5]))
      expect(black_short_castle_g.board[0, 6]).to equal_piece(Pieces::init(:k, [0, 6]))
      expect(black_short_castle_g.board[0, 5]).to equal_piece(Pieces::init(:r, [0, 5]))
      expect(white_long_castle_g.board[7, 2]).to equal_piece(Pieces::init(:K, [7, 2]))
      expect(white_long_castle_g.board[7, 3]).to equal_piece(Pieces::init(:R, [7, 3]))
      expect(black_long_castle_g.board[0, 2]).to equal_piece(Pieces::init(:k, [0, 2]))
      expect(black_long_castle_g.board[0, 3]).to equal_piece(Pieces::init(:r, [0, 3]))
    end
  end

  describe '#exec_en_passant' do
    let(:white_en_pass_exec_g) { Game.new Board.new '8/8/8/1pP5/8/8/8/8' }
    let(:black_en_pass_exec_g) { Game.new Board.new '8/8/8/8/1pP5/8/8/8' }
    it 'execute the en passant move with the infos given by can_en_passant?' do
      white_en_pass_exec_g.history.add_entry({piece: Pieces::init(:p, [3, 1]), from: [1, 1], to: [3, 1]})
      black_en_pass_exec_g.history.add_entry({piece: Pieces::init(:P, [4, 2]), from: [6, 2], to: [4, 2]})
      white_en_pass_exec_g.exec_en_passant(white_en_pass_exec_g.can_en_passant?(:w)[0])
      black_en_pass_exec_g.exec_en_passant(black_en_pass_exec_g.can_en_passant?(:b)[0])
      expect(white_en_pass_exec_g.board[2, 1]).to equal_piece(Pieces::init(:P, [2, 1]))
      expect(white_en_pass_exec_g.board[3, 1].empty?).to be true
      expect(white_en_pass_exec_g.board[3, 2].empty?).to be true
      expect(black_en_pass_exec_g.board[5, 2]).to equal_piece(Pieces::init(:p, [5, 2]))
      expect(black_en_pass_exec_g.board[4, 1].empty?).to be true
      expect(black_en_pass_exec_g.board[4, 2].empty?).to be true
    end
  end
end
