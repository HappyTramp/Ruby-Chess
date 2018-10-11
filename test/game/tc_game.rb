require 'game/index'
require 'game/components/pieces/index'
require 'game/components/board'
require_relative '../test_helper/h_board'
require_relative '../test_helper/h_piece'

# class Game; attr_accessor :board; end

describe Game, for: 'game' do
  subject { Game.new Board.new '8/3p4/2k1p3/1p1q1p2/1NB1P3/PP1R1P2/8/8' }

  describe '#all_possible_moves' do
    it 'return all correct possible move for white' do
      subject.all_possible_moves(:b).each do |pm|
        case pm[:piece].position
        when [2, 2] then
          expect(pm[:possible_moves]).to contain_exactly([1, 1], [1, 2], [2, 1], [2, 3], [3, 2])
        when [3, 3] then
          expect(pm[:possible_moves])
            .to contain_exactly([2, 3], [3, 2], [3, 4], [4, 2], [4, 3], [4, 4], [5, 3])
        end
      end
    end

    it 'return all correct possible move for black' do
      subject.all_possible_moves(:w).each do |pm|
        case pm[:piece].position
        when [5, 3] then
          expect(pm[:possible_moves])
            .to contain_exactly([3, 3], [4, 3], [5, 2], [5, 4], [6, 3], [7, 3])
        when [4, 2] then expect(pm[:possible_moves]).to contain_exactly([3, 1], [3, 3])
        when [4, 1] then
          expect(pm[:possible_moves])
            .to contain_exactly([2, 0], [2, 2], [3, 3], [6, 2], [6, 0])
        when [4, 4] then expect(pm[:possible_moves]).to contain_exactly([3, 3], [3, 4], [3, 5])
        end
      end
    end
  end
end
