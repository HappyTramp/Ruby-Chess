require 'game/history/history'
require 'game/components/pieces/pieces'
require_relative '../../test_helper/h_piece'
require_relative '../../test_helper/shortcut'
require_relative '../../matchers'

class History; attr_accessor :moves; end

describe History, for: 'history' do
  subject(:history) { History.new }

  describe '#add_entry' do
    before do
      history.add_entry([0, 0], [1, 1], Pieces.fmt('Ka8'))
      history.add_entry([1, 6], [7, 6], Pieces.fmt('rg7'))
    end

    it { expect(history.moves[0]).to eq_move('Ka8>b7') }
    it { expect(history.moves[1]).to eq_move('rg7>g1') }
  end

  describe '#last_entry' do
    it 'return last entry of the moves list' do
      history.add_entry([0, 0], [1, 1], Pieces.fmt('Ka8'))
      expect(history.last_entry).to eq_move('Ka8>b7')
    end
    it 'return a nil filled move if the moves list is empty' do
      expect(history.last_entry).to eq Move.new(from: nil, to: nil, piece: nil)
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
