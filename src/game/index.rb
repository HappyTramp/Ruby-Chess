require_relative './components/board'
require_relative './special_moves'
require_relative './history'
require_relative './check'

# class that supervise a game exectution
class Game
  include VerifySpecialMoves
  include ExecuteSpecialMoves
  include Check


  def initialize(board)
    @board = board
    @history = History.new
  end

  def all_controlled_square(color)
    pieces_controlled_square = []

    # on peut surement utiliser reduce
    (0..7).each do |i|
      @board.get_row(i).each do |sq|
        next if sq.empty? || sq.color != color

        pieces_controlled_square << {
          piece: sq,
          controlled_square: sq.controlled_square(@board)
        }
      end
    end

    pieces_controlled_square
  end
end
