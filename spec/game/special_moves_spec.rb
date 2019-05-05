require 'game/game'
require 'game/special_moves'
require 'game/history/history'
require 'game/components/pieces/pieces'
require_relative '../test_helper/h_piece'
require_relative '../test_helper/shortcut'
require_relative '../matchers'

class Game; attr_accessor :history, :board; end

describe SpecialMoves, for: 'special_moves' do
  describe '#replace_promotion' do
    let(:no_promo_g) { Game.new 'k7/8/8/8/8/8/8/7N w'  }
    let(:promo_gw)   { Game.new '8/3P4/8/8/8/8/8/7n w' }
    let(:promo_gb)   { Game.new '7K/8/8/8/8/8/3p4/8 b' }

    it { expect(no_promo_g.replace_promotion(:w)).to eq_move_array('Nh1>g3 Nh1>f2')        }
    it { expect(no_promo_g.replace_promotion(:b)).to eq_move_array('ka8>a7 ka8>b7 ka8>b8') }
    it { expect(promo_gw.replace_promotion(:w)) .to eq_move_array('Pd7>d8=u')              }
    it { expect(promo_gw.replace_promotion(:b)) .to eq_move_array('nh1>g3 nh1>f2')         }
    it { expect(promo_gb.replace_promotion(:b)) .to eq_move_array('pd2>d1=u')              }
    it { expect(promo_gb.replace_promotion(:w)) .to eq_move_array('Kh8>g8 Kh8>h7 Kh8>g7')  }
  end

  describe '#detect_castle' do
    context 'when king is in check' do
      let(:in_check_gw) { Game.new '8/8/8/8/4q3/8/8/R3K2R w' }
      let(:in_check_gb) { Game.new 'r3k2r/8/8/4Q3/8/8/8/8 b' }

      it { expect(in_check_gw.detect_castle(:w)).to be_empty }
      it { expect(in_check_gb.detect_castle(:b)).to be_empty }
    end

    context 'when the squares the king steps on are controlled by the enemy' do
      let(:cast_controlled_gw) { Game.new '8/8/8/8/3r4/8/6p1/R3K2R w' }
      let(:cast_controlled_gb) { Game.new 'r3k2r/8/6N1/5B2/8/8/8/8 b' }

      it { expect(cast_controlled_gw.detect_castle(:w)).to be_empty }
      it { expect(cast_controlled_gb.detect_castle(:b)).to be_empty }
    end

    context 'when there is a piece between the king and rook' do
      let(:piece_between_gw) { Game.new '8/8/8/8/8/8/8/RN2KB1R w' }
      let(:piece_between_gb) { Game.new 'r2qk1nr/8/8/8/8/8/8/8 b' }

      it { expect(piece_between_gw.detect_castle(:w)).to be_empty }
      it { expect(piece_between_gb.detect_castle(:b)).to be_empty }
    end

    context 'when the king as moved before' do
      let(:king_moved_gw) { Game.new '8/8/8/8/8/8/8/R3K2R w' }
      let(:king_moved_gb) { Game.new 'r3k2r/8/8/8/8/8/8/8 b' }

      before do
        king_moved_gw.history.add_entry([6, 4], [7, 4], Pieces.fmt('Ke1'))
        king_moved_gb.history.add_entry([1, 4], [0, 4], Pieces.fmt('ke8'))
      end

      it { expect(king_moved_gw.detect_castle(:w)).to be_empty }
      it { expect(king_moved_gb.detect_castle(:b)).to be_empty }
    end

    context 'when a rook as moved before' do
      let(:rook_short_moved_gw) { Game.new '8/8/8/8/8/8/8/R3K2R w' }
      let(:rook_short_moved_gb) { Game.new 'r3k2r/8/8/8/8/8/8/8 b' }
      let(:rook_long_moved_gw)  { Game.new '8/8/8/8/8/8/8/R3K2R w'  }
      let(:rook_long_moved_gb)  { Game.new 'r3k2r/8/8/8/8/8/8/8 b'  }

      before do
        rook_short_moved_gw.history.add_entry([7, 7], [6, 7], Pieces.fmt('Rh2'))
        rook_short_moved_gb.history.add_entry([0, 7], [1, 7], Pieces.fmt('rh7'))
        rook_long_moved_gw.history.add_entry([7, 0], [6, 0], Pieces.fmt('Ra2'))
        rook_long_moved_gb.history.add_entry([0, 0], [1, 0], Pieces.fmt('ra7'))
      end

      it { expect(rook_short_moved_gw.detect_castle(:w)).to eq_move_array('KO-O-O') }
      it { expect(rook_short_moved_gb.detect_castle(:b)).to eq_move_array('kO-O-O') }
      it { expect(rook_long_moved_gw.detect_castle(:w)) .to eq_move_array('KO-O')   }
      it { expect(rook_long_moved_gb.detect_castle(:b)) .to eq_move_array('kO-O')   }
    end

    context 'when there is no king or no rook' do
      let(:only_king_g) { Game.new '4k3/8/8/8/8/8/8/4K3 w' }
      let(:only_rook_g) { Game.new 'r6r/8/8/8/8/8/8/R6R w' }

      it { expect(only_king_g.detect_castle(:w)).to be_empty }
      it { expect(only_king_g.detect_castle(:b)).to be_empty }
      it { expect(only_rook_g.detect_castle(:w)).to be_empty }
      it { expect(only_rook_g.detect_castle(:b)).to be_empty }
    end

    context 'when all conditions are fulfilled' do
      let(:right_condition_gw) { Game.new '8/8/8/8/8/8/8/R3K2R w' }
      let(:right_condition_gb) { Game.new 'r3k2r/8/8/8/8/8/8/8 b' }

      it { expect(right_condition_gw.detect_castle(:w)).to eq_move_array('KO-O-O KO-O') }
      it { expect(right_condition_gb.detect_castle(:b)).to eq_move_array('kO-O-O kO-O') }
    end
  end

  describe '#detect_en_passant' do
    context 'when there is no en passant move available' do
      let(:nothing_g) { Game.new '8/8/4N1P1/5p2/1p1P4/2pq4/8/8 w' }
      let(:no_hist_g) { Game.new '8/2Nq4/8/5pP1/1p1Pp3/8/8/8 w'   }

      it { expect(nothing_g.detect_en_passant(:w)).to be_empty }
      it { expect(nothing_g.detect_en_passant(:b)).to be_empty }
      it { expect(no_hist_g.detect_en_passant(:w)).to be_empty }
      it { expect(no_hist_g.detect_en_passant(:b)).to be_empty }
    end

    context 'when en passant move available' do
      let(:enpass_gw) { Game.new 'q7/8/8/3pP3/8/8/8/3R4 w'   }
      let(:enpass_gb) { Game.new '8/8/2k2n2/7R/1Pp5/8/8/8 w' }

      before do
        enpass_gw.history.add_fmt('pd7>d5')
        enpass_gb.history.add_fmt('Pb2>b4')
      end

      it { expect(enpass_gw.detect_en_passant(:w)).to eq_move_array('Pe5>d6:d5') }
      it { expect(enpass_gb.detect_en_passant(:b)).to eq_move_array('pc4>b3:b4') }
    end

    context 'when there is an edge case where 2 pawn can en passant' do
      let(:en2pass_gw) { Game.new '8/6bp/8/2PpP3/8/8/8/6R1 w'  }
      let(:en2pass_gb) { Game.new '8/8/6n1/8/3k1pPp/2R5/8/8 b' }

      before do
        en2pass_gw.history.add_fmt('pd7>d5')
        en2pass_gb.history.add_fmt('Pg2>g4')
      end

      it { expect(en2pass_gw.detect_en_passant(:w)).to eq_move_array('Pc5>d6:d5 Pe5>d6:d5') }
      it { expect(en2pass_gb.detect_en_passant(:b)).to eq_move_array('pf4>g3:g4 ph4>g3:g4') }
    end
  end
end
