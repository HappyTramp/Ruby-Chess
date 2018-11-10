require 'game/user/analyse'
require 'game/history/move'
require_relative '../../test_helper/shortcut'

describe Analyse do
  describe '.simple_syntax' do
    context 'when the move syntax isnt correct' do
      it { expect(Analyse::simple_syntax('ae:az')).to be false }
      it { expect(Analyse::simple_syntax('O-')).to be false }
      it { expect(Analyse::simple_syntax('a9:b1')).to be false }
      it { expect(Analyse::simple_syntax('a1:i4')).to be false }
    end

    context 'when the move syntax is correct' do
      it { expect(Analyse::simple_syntax('a1:a2')).to eq type_: :normal, from: [7, 0], to: [6, 0] }
      it { expect(Analyse::simple_syntax('e4:e5')).to eq type_: :normal, from: [4, 4], to: [3, 4] }
      it { expect(Analyse::simple_syntax('h7:h8')).to eq type_: :normal, from: [1, 7], to: [0, 7] }
      it { expect(Analyse::simple_syntax('b1:c3')).to eq type_: :normal, from: [7, 1], to: [5, 2] }
      it { expect(Analyse::simple_syntax('O-O')).to eq type_: :castle, side: :short }
      it { expect(Analyse::simple_syntax('O-O-O')).to eq type_: :castle, side: :long }
    end
  end

  describe '.move_validity' do
    let(:possible_moves) do
      [sc_move(:k70to60), sc_move(:R17to07),
       Move.new(type_: :castle, side: :short)]
    end
    let(:false_input) { { type_: :normal, from: [0, 0], to: [1, 1] } }
    let(:false_castle_input) { { type_: :castle, side: :long } }
    let(:king_input) { { type_: :normal, from: [7, 0], to: [6, 0] } }
    let(:rook_input) { { type_: :normal, from: [1, 7], to: [0, 7] } }
    let(:castle_input) { { type_: :castle, side: :short } }


    context 'when move isnt in the possible moves list' do
      it { expect(Analyse::move_validity(false_input, possible_moves)).to be false        }
      it { expect(Analyse::move_validity(false_castle_input, possible_moves)).to be false }
    end

    context 'when move is in the possible move list' do
      it { expect(Analyse::move_validity(king_input, possible_moves)).to eq sc_move(:k70to60) }
      it { expect(Analyse::move_validity(rook_input, possible_moves)).to eq sc_move(:R17to07) }
      it { expect(Analyse::move_validity(castle_input, possible_moves)).to eq Move.new(type_: :castle, side: :short) }
    end
  end

  describe '.notation_to_index' do
    it { expect(Analyse::notation_to_index('a1')).to eq [7, 0] }
    it { expect(Analyse::notation_to_index('h8')).to eq [0, 7] }
    it { expect(Analyse::notation_to_index('h1')).to eq [7, 7] }
    it { expect(Analyse::notation_to_index('a8')).to eq [0, 0] }
    it { expect(Analyse::notation_to_index('e5')).to eq [3, 4] }
  end
end
