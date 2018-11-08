require 'game/index'
require 'game/special_moves'
require 'game/history/history'
require 'game/components/pieces/index'
require_relative '../test_helper/h_piece'
require_relative '../test_helper/shortcut'

class Game; attr_accessor :history, :board; end

describe SpecialMoves, for: 'special_moves' do
  describe '#detect_promotion' do
    let(:no_promo_g)    { Game.new Board.new '8/8/8/3k4/8/8/8/8' }
    let(:promo_white_g) { Game.new Board.new '3P4/8/8/8/8/8/8/8' }
    let(:promo_black_g) { Game.new Board.new '8/8/8/8/8/8/8/3p4' }

    it { expect(no_promo_g.detect_promotion).to be false }
    it { expect(promo_white_g.detect_promotion).to eq([0, 3]) }
    it { expect(promo_black_g.detect_promotion).to eq([7, 3]) }
  end

  describe '#detect_castle' do
    let(:in_check_white_g)         { Game.new Board.new '8/8/8/8/4q3/8/8/R3K2R'   }
    let(:in_check_black_g)         { Game.new Board.new 'r3k2r/8/8/4Q3/8/8/8/8'   }
    let(:cast_controlled_white_g)  { Game.new Board.new '8/8/8/8/3r4/8/6p1/R3K2R' }
    let(:cast_controlled_black_g)  { Game.new Board.new 'r3k2r/8/6N1/5B2/8/8/8/8' }
    let(:piece_between_white_g)    { Game.new Board.new '8/8/8/8/8/8/8/RN2KB1R'   }
    let(:piece_between_black_g)    { Game.new Board.new 'r2qk1nr/8/8/8/8/8/8/8'   }
    let(:king_moved_white_g)       { Game.new Board.new '8/8/8/8/8/8/8/R3K2R'     }
    let(:king_moved_black_g)       { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8'     }
    let(:king_rook_moved_white_g)  { Game.new Board.new '8/8/8/8/8/8/8/R3K2R'     }
    let(:queen_rook_moved_white_g) { Game.new Board.new '8/8/8/8/8/8/8/R3K2R'     }
    let(:king_rook_moved_black_g)  { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8'     }
    let(:queen_rook_moved_black_g) { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8'     }
    let(:right_condition_white_g)  { Game.new Board.new '8/8/8/8/8/8/8/R3K2R'     }
    let(:right_condition_black_g)  { Game.new Board.new 'r3k2r/8/8/8/8/8/8/8'     }

    context 'when the king is in check' do
      it { expect(in_check_white_g.detect_castle(:w)).to be_empty }
      it { expect(in_check_black_g.detect_castle(:b)).to be_empty }
    end

    context 'when the castling squares are controlled by the enemy' do
      it { expect(cast_controlled_white_g.detect_castle(:w)).to be_empty }
      it { expect(cast_controlled_black_g.detect_castle(:b)).to be_empty }
    end

    context 'when there is a piece between the king and rook' do
      it { expect(piece_between_white_g.detect_castle(:w)).to be_empty }
      it { expect(piece_between_black_g.detect_castle(:b)).to be_empty }
    end

    context 'when the king as moved before' do
      specify do
        king_moved_white_g.history.add_entry(piece: sc_piece(:K74), from: [6, 4], to: [7, 4])
        expect(king_moved_white_g.detect_castle(:w)).to be_empty
      end
      specify do
        king_moved_black_g.history.add_entry(piece: sc_piece(:k04), from: [1, 4], to: [0, 4])
        expect(king_moved_black_g.detect_castle(:b)).to be_empty
      end
    end

    context 'when the king rook as moved before' do
      specify do
        king_rook_moved_white_g.history.add_entry(piece: sc_piece(:R67), from: [7, 7], to: [6, 7])
        expect(king_rook_moved_white_g.detect_castle(:w))
          .to eq([Move.new(type_: :castle, color: :w, side: :long)])
      end
      specify do
        king_rook_moved_black_g.history.add_entry(piece: sc_piece(:r17), from: [0, 7], to: [1, 7])
        expect(king_rook_moved_black_g.detect_castle(:b))
          .to eq([Move.new(type_: :castle, color: :b, side: :long)])
      end
    end

    context 'when the queen rook as moved before' do
      specify do
        queen_rook_moved_white_g.history.add_entry(piece: sc_piece(:R60), from: [7, 0], to: [6, 0])
        expect(queen_rook_moved_white_g.detect_castle(:w))
          .to eq([Move.new(type_: :castle, color: :w, side: :short)])
      end
      specify do
        queen_rook_moved_black_g.history.add_entry(piece: sc_piece(:r10), from: [0, 0], to: [1, 0])
        expect(queen_rook_moved_black_g.detect_castle(:b))
          .to eq([Move.new(type_: :castle, color: :b, side: :short)])
      end
    end

    context 'when all conditions are fulfilled' do
      specify do
        expect(right_condition_white_g.detect_castle(:w))
          .to eq([Move.new(type_: :castle, color: :w, side: :short),
                  Move.new(type_: :castle, color: :w, side: :long)])
      end
      specify do
        expect(right_condition_black_g.detect_castle(:b))
          .to eq([Move.new(type_: :castle, color: :b, side: :short),
                  Move.new(type_: :castle, color: :b, side: :long)])
      end
    end
  end

  describe '#detect_en_passant' do
    let(:white_no_en_passant_g)        { Game.new Board.new '8/8/8/4Pp2/8/8/8/8'  }
    let(:black_no_en_passant_g)        { Game.new Board.new '8/8/8/8/1p1P4/8/8/8' }
    let(:white_en_passant_g)           { Game.new Board.new '8/8/8/1pP5/8/8/8/8'  }
    let(:black_en_passant_g)           { Game.new Board.new '8/8/8/8/3Pp3/8/8/8'  }
    let(:white_en_passant_edge_case_g) { Game.new Board.new '8/8/8/2PpP3/8/8/8/8' }

    context 'when there is no en passant move available' do
      it { expect(white_no_en_passant_g.detect_en_passant(:w)).to be_empty }
      it { expect(black_no_en_passant_g.detect_en_passant(:b)).to be_empty }
    end

    context 'when en passant move available' do
      it 'return a list of special move for white' do
        white_en_passant_g.history.add_entry(piece: sc_piece(:p31), from: [1, 1], to: [3, 1])
        expect(white_en_passant_g.detect_en_passant(:w))
          .to eq([Move.new([3, 2], [2, 1], type_: :en_passant, capture: [3, 1])])
      end
      it 'return a list of special move for black' do
        black_en_passant_g.history.add_entry(piece: sc_piece(:P43), from: [6, 3], to: [4, 3])
        expect(black_en_passant_g.detect_en_passant(:b))
          .to eq([Move.new([4, 4], [5, 3], type_: :en_passant, capture: [4, 3])])
      end
    end

    it 'when there is an edge case where 2 pawn can en passant' do
      white_en_passant_edge_case_g.history.add_entry(piece: sc_piece(:p33), from: [1, 3], to: [3, 3])
      expect(white_en_passant_edge_case_g.detect_en_passant(:w)).to eq(
        [Move.new([3, 2], [2, 3], type_: :en_passant, capture: [3, 3]),
         Move.new([3, 4], [2, 3], type_: :en_passant, capture: [3, 3])]
      )
    end
  end

  describe '#exec_promotion' do
    let(:white_promo_g) { Game.new Board.new '8/2P5/8/8/8/8/8/8' }
    let(:black_promo_g) { Game.new Board.new '8/8/8/8/8/8/p7/8'  }

    before do
      white_promo_g.exec_promotion([0, 2], :Q)
      black_promo_g.exec_promotion([7, 0], :r)
    end

    context 'when a pawn is replaced with the chosen piece' do
      it { expect(white_promo_g.board[0, 2]).to eq sc_piece(:Q02) }
      it { expect(black_promo_g.board[7, 0]).to eq sc_piece(:r70) }
    end
  end

  describe '#exec_castle' do
    let(:white_short_castle_g) { Game.new Board.new '8/8/8/8/8/8/8/4K2R' }
    let(:black_short_castle_g) { Game.new Board.new '4k2r/8/8/8/8/8/8/8' }
    let(:white_long_castle_g)  { Game.new Board.new '8/8/8/8/8/8/8/R3K3' }
    let(:black_long_castle_g)  { Game.new Board.new 'r3k3/8/8/8/8/8/8/8' }

    before do
      white_short_castle_g.exec_castle(Move.new(type_: :castle, color: :w, side: :short))
      black_short_castle_g.exec_castle(Move.new(type_: :castle, color: :b, side: :short))
      white_long_castle_g.exec_castle(Move.new(type_: :castle, color: :w, side: :long))
      black_long_castle_g.exec_castle(Move.new(type_: :castle, color: :b, side: :long))
    end

    context 'when the castle is executed' do
      it { expect(white_short_castle_g.board[7, 6]).to eq sc_piece(:K76) }
      it { expect(white_short_castle_g.board[7, 5]).to eq sc_piece(:R75) }
      it { expect(black_short_castle_g.board[0, 6]).to eq sc_piece(:k06) }
      it { expect(black_short_castle_g.board[0, 5]).to eq sc_piece(:r05) }
      it { expect(white_long_castle_g.board[7, 2]).to eq sc_piece(:K72) }
      it { expect(white_long_castle_g.board[7, 3]).to eq sc_piece(:R73) }
      it { expect(black_long_castle_g.board[0, 2]).to eq sc_piece(:k02) }
      it { expect(black_long_castle_g.board[0, 3]).to eq sc_piece(:r03) }
    end
  end

  describe '#exec_en_passant' do
    let(:white_en_pass_exec_g) { Game.new Board.new '8/8/8/1pP5/8/8/8/8' }
    let(:black_en_pass_exec_g) { Game.new Board.new '8/8/8/8/1pP5/8/8/8' }

    before do
      white_en_pass_exec_g.history.add_entry(piece: sc_piece(:p31), from: [1, 1], to: [3, 1])
      black_en_pass_exec_g.history.add_entry(piece: sc_piece(:P42), from: [6, 2], to: [4, 2])
      white_en_pass_exec_g.exec_en_passant(white_en_pass_exec_g.detect_en_passant(:w)[0])
      black_en_pass_exec_g.exec_en_passant(black_en_pass_exec_g.detect_en_passant(:b)[0])
    end

    context 'when en passant move is executed' do
      it { expect(white_en_pass_exec_g.board[2, 1]).to eq sc_piece(:P21) }
      it { expect(white_en_pass_exec_g.board[3, 1]).to be_empty }
      it { expect(white_en_pass_exec_g.board[3, 2]).to be_empty }
      it { expect(black_en_pass_exec_g.board[5, 2]).to eq sc_piece(:p52) }
      it { expect(black_en_pass_exec_g.board[4, 1]).to be_empty }
      it { expect(black_en_pass_exec_g.board[4, 2]).to be_empty }
    end
  end
end
