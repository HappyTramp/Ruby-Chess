require 'game/history/history'
require 'game/components/pieces/pieces'
require_relative '../../test_helper/h_piece'
require_relative '../../test_helper/shortcut'

class History; attr_accessor :moves; end

describe History, for: 'history' do
  subject(:history) { History.new }

  describe '#add_entry' do
    before do
      history.add_entry(from: [0, 0], to: [1, 1], piece: sc_piece(:K00))
      history.add_entry(from: [1, 6], to: [7, 6], piece: sc_piece(:r16))
    end

    it { expect(history.moves[0]).to eq sc_move(:K00to11) }
    it { expect(history.moves[1]).to eq sc_move(:r16to76) }
  end

  describe '#last_entry' do
    it 'return last entry of the moves list' do
      history.add_entry(from: [0, 0], to: [1, 1], piece: sc_piece(:K11))
      expect(history.last_entry).to eq Move.new [0, 0], [1, 1], sc_piece(:K11)
    end
    it 'return a nil filled move if the moves list is empty' do
      expect(history.last_entry).to eq Move.new(nil, nil, nil)
    end
  end

  # describe '.correct_move?' do
  #   context 'when incorrect move syntaxe' do
  #     it 'index out of border' do
  #       expect(History::correct_move?(from: [-1, 0], to: [0, 0], piece: sc_piece(:k00))).to be false
  #       expect(History::correct_move?(from: [0, 0], to: [0, 9], piece: sc_piece(:k00))).to be false
  #     end
  #     it 'not piece object' do
  #       expect(History::correct_move?(from: [0, 0], to: [0, 0], piece: EmptySquare.new([0, 0]))).to be false
  #     end
  #   end

  #   it 'correct move syntaxe -> true' do
  #     expect(History::correct_move?(from: [0, 0], to: [1, 1], piece: sc_piece(:k00))).to be true
  #     expect(History::correct_move?(from: [1, 2], to: [3, 5], piece: sc_piece(:q00))).to be true
  #   end
  # end
end
