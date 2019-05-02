require 'game/game'
require 'game/user/analyse'
require 'game/history/move'
require 'game/components/board'
require_relative '../../test_helper/shortcut'

class Game; attr_accessor :history, :board; end

describe Analyse do
  # describe '.pgn_syntax' do
  #   subject(:game) do
  #     g = Game.new 'R5n1/4k2P/8/ppP2Q2/8/2p1N3/rPp4N/R3K2R w'
  #     g.history.add_entry([1, 1], [3, 1], sc_piece(:p31))
  #     g
  #   end

  #   context 'when syntax is incorrect' do
  #     it { expect(game.pgn_syntax('Qh9')) .to be false }
  #     it { expect(game.pgn_syntax('Ha1')) .to be false }
  #     it { expect(game.pgn_syntax('O-O-')).to be false }
  #     it { expect(game.pgn_syntax('a8=P')).to be false }
  #   end

  #   context 'when the move isnt legal' do
  #     it { expect(game.pgn_syntax('Qa1'))  .to be false }
  #     it { expect(game.pgn_syntax('Kxe7')) .to be false }
  #     it { expect(game.pgn_syntax('Rxh2')) .to be false }
  #     it { expect(game.pgn_syntax('O-O-O')).to be false }
  #     it { expect(game.pgn_syntax('Rxb1')) .to be false }
  #     it { expect(game.pgn_syntax('Rb1+')) .to be false }
  #     it { expect(game.pgn_syntax('Rd1#')) .to be false }
  #   end

  #   context 'when syntax is correct' do
  #     let(:castle_short)  { Move.new(side: :short) }
  #     let(:pawn_advance)  { sc_move('P32>22') }
  #     let(:pawn_capture)  { sc_move('P61>52') }
  #     let(:en_passant)    { Move.new([3, 2], [2, 1], sc_piece(:P32), en_pass_capture: [3, 1]) }
  #     let(:piece_move)    { sc_move('Q35>26') }
  #     let(:piece_capture) { sc_move('R70>60') }
  #     let(:pos_spe)       { sc_move('N67>75') }
  #     let(:check)         { sc_move('Q35>36') }
  #     let(:checkmate)     { sc_move('N54>33') }
  #     let(:promotion)     { Move.new([1, 7], [0, 7], sc_piece(:P17), replacement: :R) }
  #     let(:capture_promo) { Move.new([1, 7], [0, 6], sc_piece(:P17), replacement: :B) }

  #     it { expect(game.pgn_syntax('O-O'))   .to eq castle_short  }
  #     it { expect(game.pgn_syntax('c6'))    .to eq pawn_advance  }
  #     it { expect(game.pgn_syntax('bxc3'))  .to eq pawn_capture  }
  #     it { expect(game.pgn_syntax('cxb6'))  .to eq en_passant    }
  #     it { expect(game.pgn_syntax('Qg6'))   .to eq piece_move    }
  #     it { expect(game.pgn_syntax('Rxa2'))  .to eq piece_capture }
  #     it { expect(game.pgn_syntax('Nhf1'))  .to eq pos_spe       }
  #     it { expect(game.pgn_syntax('Qg5+'))  .to eq check         }
  #     it { expect(game.pgn_syntax('Nd5#'))  .to eq checkmate     }
  #     it { expect(game.pgn_syntax('h8=R'))  .to eq promotion     }
  #     it { expect(game.pgn_syntax('hxg8=B')).to eq capture_promo }
  #   end
  # end

  # describe '.pgn_move_validity' do

  #   context 'when move isnt in the possible moves list' do
  #     let(:wrong_input)   { nm.merge(type: :normal, piece_type: 'R', to: [3, 3])     }
  #     let(:wrong_capture) { nm.merge(type: :normal, piece_type: 'Q', to: [1, 3])     }
  #     let(:no_specifier)  { nm.merge(type: :normal, piece_type: 'R', to: [1, 0])     }
  #     let(:wrong_promo)   { nm.merge(type: :promotion, to: [3, 3], replacement: 'Q') }

  #     it { expect(game.pgn_move_validity(poss_moves, wrong_input))  .to be false }
  #     it { expect(game.pgn_move_validity(poss_moves, wrong_capture)).to be false }
  #     it { expect(game.pgn_move_validity(poss_moves, no_specifier)) .to be false }
  #     it { expect(game.pgn_move_validity(poss_moves, wrong_promo))  .to be false }
  #   end

  #   context 'when move is in the possible move list' do
  #     let(:normal_move)  { nm.merge(type: :normal, to: [2, 2])                                           }
  #     let(:capture)      { nm.merge(type: :normal, piece_type: 'R', to: [7, 1], capture: true)           }
  #     let(:specifier)    { nm.merge(type: :normal, piece_type: 'N', position_specifier: 'h', to: [7, 5]) }
  #     let(:check)        { nm.merge(type: :normal, piece_type: 'Q', to: [1, 3], check: '+')              }
  #     let(:checkmate)    { nm.merge(type: :normal, piece_type: 'N', to: [3, 3], check: '#')              }
  #     let(:promotion)    { nm.merge(type: :promotion, to: [0, 7], replacement: 'B')                      }
  #     let(:castle_short) { { type: :castle, side: :short }                                               }
  #     let(:en_passant)   { nm.merge(type: :normal, position_specifier: 'c', to: [2, 1], capture: true)   }

  #     it { expect(game.pgn_move_validity(poss_moves, normal_move)) .to eq sc_move('32to22') }
  #     it { expect(game.pgn_move_validity(poss_moves, capture))     .to eq sc_move('70to71') }
  #     it { expect(game.pgn_move_validity(poss_moves, specifier))   .to eq sc_move('67to75') }
  #     it { expect(game.pgn_move_validity(poss_moves, check))       .to eq sc_move('35to13') }
  #     it { expect(game.pgn_move_validity(poss_moves, checkmate))   .to eq sc_move('54to33') }
  #     # it { expect(game.pgn_move_validity(poss_moves, promotion))   .to eq sc_move }
  #     it { expect(game.pgn_move_validity(poss_moves, castle_short)).to eq Move.new(side: :short) }
  #     it { expect(game.pgn_move_validity(poss_moves, en_passant))  .to eq en_pass_move }
  #   end
  # end

  # describe '.simple_syntax' do
  #   context 'when the move syntax is incorrect' do
  #     it { expect(game.simple_syntax('ae:az')).to be false }
  #     it { expect(game.simple_syntax('O-')).to be false }
  #     it { expect(game.simple_syntax('a9:b1')).to be false }
  #     it { expect(game.simple_syntax('a1:i4')).to be false }
  #   end

  #   context 'when the move syntax is correct' do
  #     it { expect(game.simple_syntax('a1:a2')).to eq type: :normal, from: [7, 0], to: [6, 0] }
  #     it { expect(game.simple_syntax('e4:e5')).to eq type: :normal, from: [4, 4], to: [3, 4] }
  #     it { expect(game.simple_syntax('h7:h8')).to eq type: :normal, from: [1, 7], to: [0, 7] }
  #     it { expect(game.simple_syntax('b1:c3')).to eq type: :normal, from: [7, 1], to: [5, 2] }
  #     it { expect(game.simple_syntax('O-O')).to eq type: :castle, side: :short }
  #     it { expect(game.simple_syntax('O-O-O')).to eq type: :castle, side: :long }
  #   end
  # end

  # describe '.simple_move_validity' do
  #   let(:poss_moves) do
  #     [sc_move('70to60'), sc_move('17to07'),
  #      Move.new(type: :castle, side: :short)]
  #   end
  #   let(:false_input) { { type: :normal, from: [0, 0], to: [1, 1] } }
  #   let(:false_castle_input) { { type: :castle, side: :long } }
  #   let(:king_input) { { type: :normal, from: [7, 0], to: [6, 0] } }
  #   let(:rook_input) { { type: :normal, from: [1, 7], to: [0, 7] } }
  #   let(:castle_input) { { type: :castle, side: :short } }

  #   context 'when move isnt in the possible moves list' do
  #     it { expect(game.simple_move_validity(false_input, poss_moves)).to be false        }
  #     it { expect(game.simple_move_validity(false_castle_input, poss_moves)).to be false }
  #   end

  #   context 'when move is in the possible move list' do
  #     it { expect(game.simple_move_validity(king_input, poss_moves)).to eq sc_move('70to60') }
  #     it { expect(game.simple_move_validity(rook_input, poss_moves)).to eq sc_move('17to07') }
  #     it { expect(game.simple_move_validity(castle_input, poss_moves)).to eq Move.new(type: :castle, side: :short) }
  #   end
  # end

  describe '.notation_to_index' do
    it { expect(Analyse::notation_to_index('a1')).to eq [7, 0] }
    it { expect(Analyse::notation_to_index('h8')).to eq [0, 7] }
    it { expect(Analyse::notation_to_index('h1')).to eq [7, 7] }
    it { expect(Analyse::notation_to_index('a8')).to eq [0, 0] }
    it { expect(Analyse::notation_to_index('e5')).to eq [3, 4] }
  end
end
