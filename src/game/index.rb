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

  def all_possible_moves(color)
    pieces_possible_moves = []

    # on peut surement utiliser reduce
    (0..7).each do |i|
      @board.get_row(i).each do |cell|
        next if cell.empty? || cell.color != color

        pieces_possible_moves << {
          piece: cell,
          possible_moves: cell.controlled_squares(@board)
        }
      end
    end

    pieces_possible_moves
  end
end
