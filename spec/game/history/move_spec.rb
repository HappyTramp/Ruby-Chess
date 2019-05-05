require 'game/history/move'
require 'game/components/board'
require_relative '../../matchers'

describe Move, for: 'move' do
  describe '#type' do
    let(:normal_m)  { Move::fmt('Bb7>a8')    }
    let(:castle_m)  { Move::fmt('KO-O')      }
    let(:en_pass_m) { Move::fmt('pe4>d3:d4') }
    let(:promo_m)   { Move::fmt('ph2>h1=B')  }

    it { expect(normal_m.type) .to eq :normal     }
    it { expect(castle_m.type) .to eq :castle     }
    it { expect(en_pass_m.type).to eq :en_passant }
    it { expect(promo_m.type)  .to eq :promotion  }
  end

  describe '#make' do
    let(:board)     { Board.new 'r3k2r/6P1/8/1pP3p1/3PpP2/8/1p6/R3K2R' }
    let(:board_rev) { Board.new '2kr2Q1/8/1P6/3P4/6pr/R4p2/8/1n3RK1'   }

    context 'when its a normal move' do
      let(:normal_rook_w) { Move::fmt('Ra1>a3') }
      let(:normal_rook_b) { Move::fmt('rh8>h4') }
      let(:normal_pawn_w) { Move::fmt('Pd4>d5') }
      let(:normal_pawn_b) { Move::fmt('pg5>g4') }

      before do
        normal_rook_w.make(board)
        normal_rook_b.make(board)
        normal_rook_w.make(board_rev, true)
        normal_rook_b.make(board_rev, true)
        normal_pawn_w.make(board)
        normal_pawn_b.make(board)
        normal_pawn_w.make(board_rev, true)
        normal_pawn_b.make(board_rev, true)
      end

      it { expect(board.get_at('a1')).to be_empty        }
      it { expect(board.get_at('a3')).to eq_piece('Ra3') }
      it { expect(board.get_at('h8')).to be_empty        }
      it { expect(board.get_at('h4')).to eq_piece('rh4') }
      it { expect(board.get_at('d4')).to be_empty        }
      it { expect(board.get_at('d5')).to eq_piece('Pd5') }
      it { expect(board.get_at('g5')).to be_empty        }
      it { expect(board.get_at('g4')).to eq_piece('pg4') }

      it { expect(board_rev.get_at('a1')).to eq_piece('Ra1') }
      it { expect(board_rev.get_at('a3')).to be_empty        }
      it { expect(board_rev.get_at('h8')).to eq_piece('rh8') }
      it { expect(board_rev.get_at('h4')).to be_empty        }
      it { expect(board_rev.get_at('d4')).to eq_piece('Pd4') }
      it { expect(board_rev.get_at('d5')).to be_empty        }
      it { expect(board_rev.get_at('g5')).to eq_piece('pg5') }
      it { expect(board_rev.get_at('g4')).to be_empty        }
    end

    context 'when its a castle move' do
      let(:short_w) { Move::fmt('KO-O')   }
      let(:long_b)  { Move::fmt('kO-O-O') }

      before do
        short_w.make(board)
        long_b.make(board)
        short_w.make(board_rev, true)
        long_b.make(board_rev, true)
      end

      it { expect(board.get_at('h1')).to be_empty        }
      it { expect(board.get_at('e1')).to be_empty        }
      it { expect(board.get_at('g1')).to eq_piece('Kg1') }
      it { expect(board.get_at('f1')).to eq_piece('Rf1') }
      it { expect(board.get_at('a8')).to be_empty        }
      it { expect(board.get_at('e8')).to be_empty        }
      it { expect(board.get_at('c8')).to eq_piece('kc8') }
      it { expect(board.get_at('d8')).to eq_piece('rd8') }

      it { expect(board_rev.get_at('h1')).to eq_piece('Rh1') }
      it { expect(board_rev.get_at('e1')).to eq_piece('Ke1') }
      it { expect(board_rev.get_at('g1')).to be_empty        }
      it { expect(board_rev.get_at('f1')).to be_empty        }
      it { expect(board_rev.get_at('a8')).to eq_piece('ra8') }
      it { expect(board_rev.get_at('e8')).to eq_piece('ke8') }
      it { expect(board_rev.get_at('c8')).to be_empty        }
      it { expect(board_rev.get_at('d8')).to be_empty        }
    end

    context 'when its an en passant move' do
      let(:en_pass_w) { Move::fmt('Pc5>b6:b5') }
      let(:en_pass_b) { Move::fmt('pe4>f3:f4') }

      before do
        en_pass_w.make(board)
        en_pass_b.make(board)
        en_pass_w.make(board_rev, true)
        en_pass_b.make(board_rev, true)
      end

      it { expect(board.get_at('c5')).to be_empty        }
      it { expect(board.get_at('b5')).to be_empty        }
      it { expect(board.get_at('b6')).to eq_piece('Pb6') }
      it { expect(board.get_at('e4')).to be_empty        }
      it { expect(board.get_at('f4')).to be_empty        }
      it { expect(board.get_at('f3')).to eq_piece('pf3') }

      it { expect(board_rev.get_at('c5')).to eq_piece('Pc5') }
      it { expect(board_rev.get_at('b5')).to eq_piece('pb5') }
      it { expect(board_rev.get_at('b6')).to be_empty        }
      it { expect(board_rev.get_at('e4')).to eq_piece('pe4') }
      it { expect(board_rev.get_at('f4')).to eq_piece('Pf4') }
      it { expect(board_rev.get_at('f3')).to be_empty        }
    end

    context 'when its a promotion move' do
      let(:promo_w) { Move::fmt('Pg7>g8=Q') }
      let(:promo_b) { Move::fmt('pb2>b1=N') }

      before do
        promo_w.make(board)
        promo_b.make(board)
        promo_w.make(board_rev, true)
        promo_b.make(board_rev, true)
      end

      it { expect(board.get_at('g7')).to be_empty        }
      it { expect(board.get_at('g8')).to eq_piece('Qg8') }
      it { expect(board.get_at('b2')).to be_empty        }
      it { expect(board.get_at('b1')).to eq_piece('nb1') }

      it { expect(board_rev.get_at('g7')).to eq_piece('Pg7') }
      it { expect(board_rev.get_at('g8')).to be_empty        }
      it { expect(board_rev.get_at('b2')).to eq_piece('pb2') }
      it { expect(board_rev.get_at('b1')).to be_empty        }
    end
  end

  describe '#==' do
    let(:normal)  { Move::fmt('Qa8>b8')    }
    let(:castle)  { Move::fmt('kO-O-O')    }
    let(:en_pass) { Move::fmt('pb5>a6:b5') }
    let(:promo)   { Move::fmt('Ph7>h8=N')  }

    it { expect(normal == Move::fmt('Qa8>b8'))    .to be true  }
    it { expect(normal == Move::fmt('qa8>b8'))    .to be false }
    it { expect(normal == Move::fmt('Qa7>b8'))    .to be false }
    it { expect(normal == Move::fmt('Qa8>c8'))    .to be false }
    it { expect(castle == Move::fmt('kO-O-O'))    .to be true  }
    it { expect(castle == Move::fmt('KO-O-O'))    .to be false }
    it { expect(castle == Move::fmt('kO-O'))      .to be false }
    it { expect(castle == Move::fmt('pa2>a4'))    .to be false }
    it { expect(en_pass == Move::fmt('pb5>a6:b5')).to be true  }
    it { expect(en_pass == Move::fmt('pb5>c6:c5')).to be false }
    it { expect(promo == Move::fmt('Ph7>h8=N'))   .to be true  }
    it { expect(promo == Move::fmt('Ph7>h8=B'))   .to be false }
  end

  describe '.fmt' do
    let(:fmt_normal_w)  { Move.new(from: [4, 4], to: [3, 3], piece: Pieces::fmt('Be4'))                          }
    let(:fmt_normal_b)  { Move.new(from: [6, 0], to: [4, 0], piece: Pieces::fmt('pa2'))                          }
    let(:fmt_long_w)    { Move.new(from: [7, 4], to: [7, 2], piece: Pieces::fmt('Ke1'), side: :long)             }
    let(:fmt_short_b)   { Move.new(from: [0, 4], to: [0, 6], piece: Pieces::fmt('ke8'), side: :short)            }
    let(:fmt_promo_w)   { Move.new(from: [1, 7], to: [0, 7], piece: Pieces::fmt('Ph7'), replacement: :Q)         }
    let(:fmt_promo_b)   { Move.new(from: [6, 4], to: [7, 4], piece: Pieces::fmt('pe2'), replacement: :R)         }
    let(:fmt_en_pass_w) { Move.new(from: [3, 4], to: [2, 5], piece: Pieces::fmt('Pe5'), en_pass_capture: [3, 5]) }
    let(:fmt_en_pass_b) { Move.new(from: [4, 3], to: [5, 2], piece: Pieces::fmt('pd4'), en_pass_capture: [4, 2]) }

    it { expect(Move::fmt('Be4>d5'))   .to eq fmt_normal_w  }
    it { expect(Move::fmt('pa2>a4'))   .to eq fmt_normal_b  }
    it { expect(Move::fmt('KO-O-O'))   .to eq fmt_long_w    }
    it { expect(Move::fmt('kO-O'))     .to eq fmt_short_b   }
    it { expect(Move::fmt('Ph7>h8=Q')) .to eq fmt_promo_w   }
    it { expect(Move::fmt('pe2>e1=R')) .to eq fmt_promo_b   }
    it { expect(Move::fmt('Pe5>f6:f5')).to eq fmt_en_pass_w }
    it { expect(Move::fmt('pd4>c3:c4')).to eq fmt_en_pass_b }
  end

  describe '.fmt_array' do
    let(:promo_normal_castle) { [Move::fmt('pf2>f1=B'), Move::fmt('Bd3>e4'), Move::fmt('KO-O')]      }
    let(:enpass_normal_promo) { [Move::fmt('Pe5>d6:d5'), Move::fmt('Rd3>d8'), Move::fmt('Pg7>g8=R')] }
    let(:normal_3)            { [Move::fmt('kg6>f5'), Move::fmt('qh1>a8'), Move::fmt('Pe2>e4')]      }
    let(:more_moves) do
      [Move::fmt('Bf1>g2'), Move::fmt('ra1>d1'), Move::fmt('kO-O-O'),
       Move::fmt('pa4>b3:b4'), Move::fmt('Ng1>f3'), Move::fmt('Qd3>d8')]
    end

    it { expect(Move::fmt_array('pf2>f1=B Bd3>e4 KO-O'))     .to contain_exactly(*promo_normal_castle) }
    it { expect(Move::fmt_array('Pe5>d6:d5 Rd3>d8 Pg7>g8=R')).to contain_exactly(*enpass_normal_promo) }
    it { expect(Move::fmt_array('kg6>f5 qh1>a8 Pe2>e4'))     .to contain_exactly(*normal_3)            }
    it { expect(Move::fmt_array('Bf1>g2 ra1>d1 kO-O-O pa4>b3:b4 Ng1>f3 Qd3>d8')).to contain_exactly(*more_moves) }
  end
end
