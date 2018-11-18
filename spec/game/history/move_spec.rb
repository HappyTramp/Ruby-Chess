require 'game/history/move'
require 'game/game'
require_relative '../../test_helper/shortcut'

describe Move, for: 'move' do
  describe '#type' do
    let(:normal_m)  { Move.new(:K, [0, 0], [1, 1])                      }
    let(:castle_m)  { Move.new(side: :short)                            }
    let(:en_pass_m) { Move.new([3, 1], [2, 0], en_pass_capture: [3, 0]) }

    it { expect(normal_m.type) .to eq :normal     }
    it { expect(castle_m.type) .to eq :castle     }
    it { expect(en_pass_m.type).to eq :en_passant }
  end

  describe '#make' do
    let(:white_g)        { Game.new 'r3k2r/6P1/8/1pP5/4pP2/8/1p6/R3K2R w' }
    let(:black_g)        { Game.new 'r3k2r/6P1/8/1pP5/4pP2/8/1p6/R3K2R b' }
    let(:white_revert_g) { Game.new '2kr2Q1/8/1P6/8/7r/R4p2/8/1n3RK1 w' }
    let(:black_revert_g) { Game.new '2kr2Q1/8/1P6/8/7r/R4p2/8/1n3RK1 b' }

    context 'when its a normal move' do
      let(:white_normal_m) { Move.new([7, 0], [5, 0], sc_piece(:R70)) }
      let(:black_normal_m) { Move.new([0, 7], [4, 7], sc_piece(:r07)) }

      before do
        white_normal_m.make(white_g.board, white_g.turn_color)
        black_normal_m.make(black_g.board, black_g.turn_color)
        white_normal_m.make(white_revert_g.board, white_revert_g.turn_color, true)
        black_normal_m.make(black_revert_g.board, black_revert_g.turn_color, true)
      end

      it { expect(white_g.board[7, 0]).to be_empty          }
      it { expect(white_g.board[5, 0]).to eq sc_piece(:R50) }
      it { expect(black_g.board[0, 7]).to be_empty          }
      it { expect(black_g.board[4, 7]).to eq sc_piece(:r47) }

      it { expect(white_revert_g.board[7, 0]).to eq sc_piece(:R70) }
      it { expect(white_revert_g.board[5, 0]).to be_empty          }
      it { expect(black_revert_g.board[0, 7]).to eq sc_piece(:r07) }
      it { expect(black_revert_g.board[4, 7]).to be_empty          }
    end

    context 'when its a castle move' do
      let(:white_short_castle_m) { Move.new(side: :short) }
      let(:black_long_castle_m)  { Move.new(side: :long)  }

      before do
        white_short_castle_m.make(white_g.board, white_g.turn_color)
        black_long_castle_m.make(black_g.board, black_g.turn_color)
        white_short_castle_m.make(white_revert_g.board, white_revert_g.turn_color, true)
        black_long_castle_m.make(black_revert_g.board, black_revert_g.turn_color, true)
      end

      it { expect(white_g.board[7, 7]).to be_empty          }
      it { expect(white_g.board[7, 4]).to be_empty          }
      it { expect(white_g.board[7, 6]).to eq sc_piece(:K76) }
      it { expect(white_g.board[7, 5]).to eq sc_piece(:R75) }
      it { expect(black_g.board[0, 0]).to be_empty          }
      it { expect(black_g.board[0, 4]).to be_empty          }
      it { expect(black_g.board[0, 2]).to eq sc_piece(:k02) }
      it { expect(black_g.board[0, 3]).to eq sc_piece(:r03) }

      it { expect(white_revert_g.board[7, 7]).to eq sc_piece(:R77) }
      it { expect(white_revert_g.board[7, 4]).to eq sc_piece(:K74) }
      it { expect(white_revert_g.board[7, 6]).to be_empty          }
      it { expect(white_revert_g.board[7, 5]).to be_empty          }
      it { expect(black_revert_g.board[0, 0]).to eq sc_piece(:r00) }
      it { expect(black_revert_g.board[0, 4]).to eq sc_piece(:k04) }
      it { expect(black_revert_g.board[0, 2]).to be_empty          }
      it { expect(black_revert_g.board[0, 3]).to be_empty          }
    end

    context 'when its an en passant move' do
      let(:white_en_pass_m) { Move.new([3, 2], [2, 1], sc_piece(:P32), en_pass_capture: [3, 1]) }
      let(:black_en_pass_m) { Move.new([4, 4], [5, 5], sc_piece(:p44), en_pass_capture: [4, 5]) }

      before do
        white_en_pass_m.make(white_g.board, white_g.turn_color)
        black_en_pass_m.make(black_g.board, black_g.turn_color)
        white_en_pass_m.make(white_revert_g.board, white_revert_g.turn_color, true)
        black_en_pass_m.make(black_revert_g.board, black_revert_g.turn_color, true)
      end

      it { expect(white_g.board[3, 2]).to be_empty          }
      it { expect(white_g.board[3, 1]).to be_empty          }
      it { expect(white_g.board[2, 1]).to eq sc_piece(:P21) }
      it { expect(black_g.board[4, 4]).to be_empty          }
      it { expect(black_g.board[4, 5]).to be_empty          }
      it { expect(black_g.board[5, 5]).to eq sc_piece(:p55) }

      it { expect(white_revert_g.board[3, 2]).to eq sc_piece(:P32) }
      it { expect(white_revert_g.board[3, 1]).to eq sc_piece(:p31) }
      it { expect(white_revert_g.board[2, 1]).to be_empty          }
      it { expect(black_revert_g.board[4, 4]).to eq sc_piece(:p44) }
      it { expect(black_revert_g.board[4, 5]).to eq sc_piece(:P45) }
      it { expect(black_revert_g.board[5, 5]).to be_empty          }
    end

    context 'when its a promotion move' do
      let(:white_promo_m) { Move.new([1, 6], [0, 6], sc_piece(:P16), replacement: :Q) }
      let(:black_promo_m) { Move.new([6, 1], [7, 1], sc_piece(:p61), replacement: :N) }

      before do
        white_promo_m.make(white_g.board, white_g.turn_color)
        black_promo_m.make(black_g.board, black_g.turn_color)
        white_promo_m.make(white_revert_g.board, white_revert_g.turn_color, true)
        black_promo_m.make(black_revert_g.board, black_revert_g.turn_color, true)
      end

      it { expect(white_g.board[1, 6]).to be_empty          }
      it { expect(white_g.board[0, 6]).to eq sc_piece(:Q06) }
      it { expect(black_g.board[6, 1]).to be_empty          }
      it { expect(black_g.board[7, 1]).to eq sc_piece(:n71) }

      it { expect(white_revert_g.board[1, 6]).to eq sc_piece(:P16) }
      it { expect(white_revert_g.board[0, 6]).to be_empty          }
      it { expect(black_revert_g.board[6, 1]).to eq sc_piece(:p61) }
      it { expect(black_revert_g.board[7, 1]).to be_empty          }
    end
  end

  describe '#==' do
    let(:compare_move)    { Move.new(:Q, [0, 0], [0, 1])                      }
    let(:compare_castle)  { Move.new(side: :long)                             }
    let(:compare_en_pass) { Move.new([3, 1], [2, 0], en_pass_capture: [3, 0]) }

    it { expect(compare_move == Move.new(:Q, [0, 0], [0, 1])).to be true  }
    it { expect(compare_move == Move.new(:R, [0, 0], [0, 1])).to be false }
    it { expect(compare_move == Move.new(:Q, [1, 1], [0, 1])).to be false }
    it { expect(compare_move == Move.new(:Q, [0, 0], [1, 1])).to be false }
    it { expect(compare_castle == Move.new(side: :long))     .to be true  }
    it { expect(compare_castle == Move.new(side: :short))    .to be false }
    it { expect(compare_en_pass == Move.new([3, 1], [2, 0], en_pass_capture: [3, 0])).to be true  }
    it { expect(compare_en_pass == Move.new([3, 1], [2, 0], en_pass_capture: [4, 0])).to be false }
  end
end
