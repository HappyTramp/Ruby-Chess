require 'game/history/move'
require_relative '../../test_helper/shortcut'

describe Move, for: 'move' do
  describe '#initialize' do
    context 'with a normal move' do
      let(:normal_move) { Move.new([0, 0], [1, 1], sc_piece(:k00)) }

      it { expect(normal_move.from).to eq [0, 0]          }
      it { expect(normal_move.to).to eq [1, 1]            }
      it { expect(normal_move.piece).to eq sc_piece(:k00) }
    end

    context 'with a special move' do
      let(:castle_move)     { Move.new(type_: :castle, color: :w, side: :short)             }
      let(:en_passant_move) { Move.new([3, 1], [2, 0], type_: :en_passant, capture: [3, 0]) }

      it { expect(castle_move.type_).to be :castle         }
      it { expect(castle_move.color).to be :w              }
      it { expect(castle_move.side).to be :short           }
      it { expect(en_passant_move.type_).to be :en_passant }
      it { expect(en_passant_move.capture).to eq [3, 0]    }
    end
  end

  describe '#==' do
    let(:compared_move)    { Move.new([0, 1], [0, 1], sc_piece(:R01))         }
    let(:compared_special) { Move.new(type_: :castle, color: :b, side: :long) }

    it { expect(compared_move == Move.new([0, 1], [0, 1], sc_piece(:R01))).to be true              }
    it { expect(compared_move == Move.new([0, 0], [0, 1], sc_piece(:R01))).to be false             }
    it { expect(compared_move == Move.new([0, 1], [0, 3], sc_piece(:R01))).to be false             }
    it { expect(compared_move == Move.new([0, 1], [0, 1], sc_piece(:k01))).to be false             }
    it { expect(compared_special == Move.new(type_: :castle, color: :b, side: :long)).to be true   }
    it { expect(compared_special == Move.new(type_: :castle, color: :b, side: :short)).to be false }
  end
end
