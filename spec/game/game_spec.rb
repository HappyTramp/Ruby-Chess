require 'game/game'
require 'game/history/history'
require 'game/components/pieces/pieces'
require 'game/components/board'
require_relative '../test_helper/h_board'
require_relative '../test_helper/h_piece'
require_relative '../test_helper/shortcut'

class Game; attr_accessor :board; end
# Move = History::Move

describe Game, for: 'game' do
  subject(:game) { Game.new '8/8/1prP4/2P5/8/8/8/8 w' }

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
        [sc_move(:P23to13),
         sc_move(:P32to21)]
      end
      let(:black_poss_move) do
        [sc_move(:p21to31),
         sc_move(:p21to32),
         sc_move(:r22to32),
         sc_move(:r22to23),
         sc_move(:r22to02),
         sc_move(:r22to12)]
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
