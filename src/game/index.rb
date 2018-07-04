require_relative './components/board'
require_relative './special_moves'

# class that supervise a game exectution
class Game
  include SpecialMoves

  def initialize(board)
    @board = board
    @moves_historic = []
  end

  def all_pieces_possible_moves
    pieces_possible_moves = []

    # on peut surement utiliser reduce
    (0..7).each do |i|
      @board.get_row(i).each do |cell|
        next if cell.empty?

        pieces_possible_moves << {
          piece: cell,
          position: cell.position,
          possible_moves: cell.get_possible_moves(@board)
        }
      end
    end

    pieces_possible_moves
  end
end
