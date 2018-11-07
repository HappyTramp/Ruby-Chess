require 'game/history'
require 'game/components/pieces/index'
require_relative '../test_helper/h_piece'
require_relative '../test_helper/h_move'

class History; attr_accessor :moves; end
Move = History::Move

describe History, for: 'history' do
  subject(:history) { History.new }

  describe '.Move' do
    describe '#==' do
      let(:compared_move) { Move.new([0, 0], [0, 1], Pieces::init(:R, [0, 1])) }

      it { expect(compared_move == Move.new([0, 0], [0, 1], Pieces::init(:R, [0, 1]))).to be true }
      it { expect(compared_move == Move.new([2, 0], [0, 1], Pieces::init(:R, [0, 1]))).to be false }
      it { expect(compared_move == Move.new([0, 0], [0, 3], Pieces::init(:R, [0, 1]))).to be false }
      it { expect(compared_move == Move.new([0, 0], [0, 1], Pieces::init(:k, [0, 1]))).to be false }
    end
  end

  describe '#add_entry' do
    before do
      history.add_entry(from: [0, 0], to: [1, 1], piece: Pieces::init(:K, [1, 1]))
      history.add_entry(from: [1, 6], to: [7, 6], piece: Pieces::init(:r, [7, 6]))
    end

    it 'add first entry to the moves list' do
      expect(history.moves[0]).to eq Move.new([0, 0], [1, 1], Pieces::init(:K, [1, 1]))
    end
    it 'add second entry to the moves list' do
      expect(history.moves[1]).to eq Move.new([1, 6], [7, 6], Pieces::init(:r, [7, 6]))
    end
  end

  describe '#last_entry' do
    it 'return last entry of the moves list' do
      history.add_entry(from: [0, 0], to: [1, 1], piece: Pieces::init(:K, [1, 1]))
      expect(history.last_entry).to eq Move.new [0, 0], [1, 1], Pieces::init(:K, [1, 1])
    end
    it 'return a nil filled move if the moves list is empty' do
      expect(history.last_entry).to eq Move.new(nil, nil, nil)
    end
  end

  # describe '.correct_move?' do
  #   context 'when incorrect move syntaxe' do
  #     it 'index out of border' do
  #       expect(History::correct_move?(from: [-1, 0], to: [0, 0], piece: Pieces::init(:k, [0, 0]))).to be false
  #       expect(History::correct_move?(from: [0, 0], to: [0, 9], piece: Pieces::init(:k, [0, 0]))).to be false
  #     end
  #     it 'not piece object' do
  #       expect(History::correct_move?(from: [0, 0], to: [0, 0], piece: EmptySquare.new([0, 0]))).to be false
  #     end
  #   end

  #   it 'correct move syntaxe -> true' do
  #     expect(History::correct_move?(from: [0, 0], to: [1, 1], piece: Pieces::init(:k, [0, 0]))).to be true
  #     expect(History::correct_move?(from: [1, 2], to: [3, 5], piece: Pieces::init(:q, [0, 0]))).to be true
  #   end
  # end
end
