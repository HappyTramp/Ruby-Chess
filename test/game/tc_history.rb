require 'game/history'
require 'game/components/pieces/index'
require_relative '../test_helper/h_piece'

class History; attr_accessor :moves; end

describe History, for: 'history' do
  describe '#add_entry' do
    it 'add the entry to the moves list' do
      subject.add_entry({from: [0, 0], to: [1, 1], piece: Pieces::init(:K, [1, 1])})
      subject.add_entry({from: [1, 6], to: [7, 6], piece: Pieces::init(:r, [7, 6])})
      subject.moves.zip([
        {from: [0, 0], to: [1, 1], piece: Pieces::init(:K, [1, 1])},
        {from: [1, 6], to: [7, 6], piece: Pieces::init(:r, [7, 6])}])
        .each do |e|
          expect(e[0][:from]).to eq(e[1][:from])
          expect(e[0][:to]).to eq(e[1][:to])
          expect(e[0][:piece]).to equal_piece(e[1][:piece])
        end
    end
  end

  describe '#last_entry' do
    it 'return last entry of the moves list' do
      subject.add_entry({from: [0, 0], to: [1, 1], piece: Pieces::init(:K, [1, 1])})
      expect(subject.last_entry[:from]).to eq [0, 0]
      expect(subject.last_entry[:to]).to eq [1, 1]
    end
    it 'return a nil filled move if the moves list is empty' do
      expect(subject.last_entry).to eq({from: nil, to: nil, piece: nil})
    end
  end

  describe '#self.correct_move?' do
    context 'incorrect move syntaxe -> false' do
      it 'index out of border' do
        expect(History::correct_move?({from: [-1, 0], to: [0, 0], piece: Pieces::init(:k, [0, 0])})).to be false
        expect(History::correct_move?({from: [0, 0], to: [0, 9], piece: Pieces::init(:k, [0, 0])})).to be false
      end
      it 'not piece object' do
        expect(History::correct_move?({from: [0, 0], to: [0, 0], piece: EmptySquare.new([0, 0])})).to be false
      end
    end
    it 'correct move syntaxe -> true' do
      expect(History::correct_move?({from: [0, 0], to: [1, 1], piece: Pieces::init(:k, [0, 0])})).to be true
      expect(History::correct_move?({from: [1, 2], to: [3, 5], piece: Pieces::init(:q, [0, 0])})).to be true
    end
  end
end
