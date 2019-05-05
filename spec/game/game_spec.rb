require 'game/game'
require 'game/history/history'
require 'game/components/pieces/pieces'
require 'game/components/board'
require_relative '../test_helper/h_board'
require_relative '../test_helper/h_piece'
require_relative '../test_helper/shortcut'
require_relative '../matchers'

class Game; attr_accessor :board; end

describe Game, for: 'game_rp' do
  let(:rook_pawn_g) { Game.new '8/8/1prP4/2P5/8/8/8/8 w' }
  let(:bish_knig_g) { Game.new 'n7/1B6/2p5/8/8/8/8/8 w'  }

  describe '#all_controlled_square' do
    it { expect(rook_pawn_g.all_controlled_square(:w)).to eq_index_array('b6 c7 e7 d6')       }
    it { expect(rook_pawn_g.all_controlled_square(:b)).to eq_index_array('c5 d6 b6 c7 c8 a5') }
    it { expect(bish_knig_g.all_controlled_square(:w)).to eq_index_array('a8 a6 c8 c6')       }
    it { expect(bish_knig_g.all_controlled_square(:b)).to eq_index_array('b6 c7 b5 d5')       }
  end

  describe '#all_normal_moves' do
    context 'with only_pos flag off' do
      it { expect(rook_pawn_g.all_normal_moves(:w)).to eq_move_array('Pc5>b6 Pd6>d7')                             }
      it { expect(rook_pawn_g.all_normal_moves(:b)).to eq_move_array('pb6>b5 pb6>c5 rc6>c5 rc6>d6 rc6>c7 rc6>c8') }
      it { expect(bish_knig_g.all_normal_moves(:w)).to eq_move_array('Bb7>a8 Bb7>a6 Bb7>c8 Bb7>c6')               }
      it { expect(bish_knig_g.all_normal_moves(:b)).to eq_move_array('na8>b6 na8>c7 pc6>c5')                      }
    end

    context 'with only_pos flag on' do
      it { expect(rook_pawn_g.all_normal_moves(:w, only_pos: true)).to eq_index_array('d7 b6')          }
      it { expect(rook_pawn_g.all_normal_moves(:b, only_pos: true)).to eq_index_array('b5 c5 d6 c7 c8') }
      it { expect(bish_knig_g.all_normal_moves(:w, only_pos: true)).to eq_index_array('a8 a6 c8 c6')    }
      it { expect(bish_knig_g.all_normal_moves(:b, only_pos: true)).to eq_index_array('b6 c7 c5')       }
    end
  end

  describe '#all_moves' do
    let(:normal_g)   { Game.new 'NqB5/1ppp4/8/8/8/8/8/8 w'          }
    let(:castle_g)   { Game.new 'r3k3/p7/2p5/8/8/4P3/7P/4K2R w'     }
    let(:promo_g)    { Game.new 'n7/2P5/8/8/8/8/3p4/7K w'           }
    let(:en_pass_gw) { Game.new 'k7/8/8/2pP4/5pP1/8/8/7N w'         }
    let(:en_pass_gb) { Game.new 'k7/8/8/2pP4/5pP1/8/8/7N b'         }
    let(:all_gw)     { Game.new '4k2r/P6p/8/4pP2/2Pp4/8/P6p/R3K3 w' }
    let(:all_gb)     { Game.new '4k2r/P6p/8/4pP2/2Pp4/8/P6p/R3K3 b' }
    let(:normal_mw)  { 'Na8>c7 Na8>b6 Bc8>b7 Bc8>d7'                                    }
    let(:normal_mb)  { 'qb8>a8 qb8>c8 qb8>a7 pb7>b6 pb7>b5 pc7>c6 pc7>c5 pd7>d6 pd7>d5' }
    let(:castle_mw)  { 'Pe3>e4 Ph2>h3 Ph2>h4 Rh1>g1 Rh1>f1 Ke1>f1 Ke1>f2 Ke1>e2 Ke1>d2 Ke1>d1 KO-O' }
    let(:castle_mb)  { 'ra8>b8 ra8>c8 ra8>d8 pa7>a6 pa7>a5 pc6>c5 ke8>d8 ke8>d7 ke8>e7 ke8>f7 ke8>f8 kO-O-O' }
    let(:en_pass_mw) { 'Nh1>g3 Nh1>f2 Pg4>g5 Pd5>d6 Pd5>c6:c5'        }
    let(:en_pass_mb) { 'pf4>f3 pc5>c4 ka8>b8 ka8>b7 ka8>a7 pf4>g3:g4' }
    let(:promo_mw)   { 'Kh1>h2 Kh1>g1 Kh1>g2 Pc7>c8=u'                }
    let(:promo_mb)   { 'na8>c7 na8>b6 pd2>d1=u'                       }
    let(:all_mw) do
      'Ra1>b1 Ra1>c1 Ra1>d1 Ke1>d1 Ke1>d2 Ke1>e2 Ke1>f2 Ke1>f1 '\
      'Pc4>c5 Pf5>f6 Pa2>a3 Pa2>a4 KO-O-O Pa7>a8=u Pf5>e6:e5'
    end
    let(:all_mb) do
      'rh8>g8 rh8>f8 ke8>f8 ke8>f7 ke8>e7 ke8>d7 ke8>d8 '\
      'ph7>h6 ph7>h5 pe5>e4 pd4>d3 kO-O ph2>h1=u pd4>c3:c4'
    end

    before do
      en_pass_gw.history.add_entry([1, 2], [3, 2], Pieces.fmt('pc5'))
      en_pass_gb.history.add_entry([6, 6], [4, 6], Pieces.fmt('Pg4'))
      all_gw.history.add_entry([1, 4], [3, 4], Pieces.fmt('pe5'))
      all_gb.history.add_entry([6, 2], [4, 2], Pieces.fmt('Pc4'))
    end

    it { expect(normal_g.all_moves(:w)) .to eq_move_array(normal_mw)   }
    it { expect(normal_g.all_moves(:b)) .to eq_move_array(normal_mb)   }
    it { expect(castle_g.all_moves(:w)) .to eq_move_array(castle_mw)   }
    it { expect(castle_g.all_moves(:b)) .to eq_move_array(castle_mb)   }
    it { expect(promo_g.all_moves(:w))  .to eq_move_array(promo_mw)    }
    it { expect(promo_g.all_moves(:b))  .to eq_move_array(promo_mb)    }
    it { expect(en_pass_gw.all_moves(:w)).to eq_move_array(en_pass_mw) }
    it { expect(en_pass_gb.all_moves(:b)).to eq_move_array(en_pass_mb) }
    it { expect(all_gw.all_moves(:w))    .to eq_move_array(all_mw)     }
    it { expect(all_gb.all_moves(:b))    .to eq_move_array(all_mb)     }
  end
end
