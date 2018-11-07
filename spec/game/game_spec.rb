require 'game/index'
require 'game/history'
require 'game/components/pieces/index'
require 'game/components/board'
require_relative '../test_helper/h_board'
require_relative '../test_helper/h_piece'

class Game; attr_accessor :board; end
# Move = History::Move

describe Game, for: 'game' do
  subject(:game) { Game.new Board.new '8/8/1prP4/2P5/8/8/8/8' }

  let(:Move) { History::Move }

  describe '#all_controlled_square' do
    it 'return all the position controlled by white' do
      expect(game.all_controlled_square(:w))
        .to contain_exactly([2, 1], [2, 3], [1, 2], [1, 4])
    end

    it 'return all the position controlled by black' do
      expect(game.all_controlled_square(:b))
        .to contain_exactly([3, 0], [3, 2], [2, 3], [0, 2], [1, 2], [2, 1])
    end
  end

  describe '#all_possible_move' do
    context 'with only_position flag off' do
      let(:white_poss_move) do
        [Move.new([2, 3], [1, 3], Pieces::init(:P, [2, 3])),
         Move.new([3, 2], [2, 1], Pieces::init(:P, [3, 2]))]
      end
      let(:black_poss_move) do
        [Move.new([2, 1], [3, 1], Pieces::init(:p, [2, 1])),
         Move.new([2, 1], [3, 2], Pieces::init(:p, [2, 1])),
         Move.new([2, 2], [3, 2], Pieces::init(:r, [2, 2])),
         Move.new([2, 2], [2, 3], Pieces::init(:r, [2, 2])),
         Move.new([2, 2], [0, 2], Pieces::init(:r, [2, 2])),
         Move.new([2, 2], [1, 2], Pieces::init(:r, [2, 2]))]
      end

      it 'return all the possible moves position of all pieces for white' do
        expect(game.all_possible_move(:w)).to contain_exactly(*white_poss_move)
      end
      it 'return all the possible moves position of all pieces for black' do
        expect(game.all_possible_move(:b)).to contain_exactly(*black_poss_move)
      end
    end

    context 'with only_position flag on' do
      it 'return position of the square where moves are possible for white' do
        expect(game.all_possible_move(:w, only_position: true))
          .to contain_exactly([1, 3], [2, 1])
      end
      it 'return position of the square where moves are possible for black' do
        expect(game.all_possible_move(:b, only_position: true))
          .to contain_exactly([3, 1], [3, 2], [2, 3], [0, 2], [1, 2])
      end
    end
  end
end
