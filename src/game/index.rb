require_relative './components/board'
require_relative './special_moves'
require_relative './history'
require_relative './check'

# class that supervise a game execution
class Game
  include SpecialMoves
  include Check

  def initialize(board)
    @board = board
    @history = History.new
  end

  # all pieces controlled square of a color
  def all_controlled_square(color)
    @board.map_every_square do |s|
      next [] unless s.color == color

      s.controlled_square(@board)
    end.flatten(1).uniq
  end

  # all pieces possible moves position of a color
  def all_possible_move(color, only_position: false)
    @board.map_every_square do |s|
      next [] unless s.color == color
      next s.possible_move(@board) if only_position

      s.possible_move(@board).map do |pm|
        History::Move.new(s.position, pm, s)
      end
    end.flatten(1).uniq
  end
end
