require_relative './components/board'
require_relative './special_moves'
require_relative './history'
require_relative './check'

# class that supervise a game execution
class Game
  include VerifySpecialMoves
  include ExecuteSpecialMoves
  include Check


  def initialize(board)
    @board = board
    @history = History.new
  end

  # all pieces controlled square of a color
  def all_controlled_square(color)
    pieces_controlled_square = []

    (0..7).each do |i|
      @board.row(i).each do |s|
        next if s.empty? || s.color != color

        pieces_controlled_square << {
          piece: s,
          controlled_square: s.controlled_square(@board)
        }
      end
    end

    pieces_controlled_square
  end
  
  # all pieces controlled square of a color
  def all_possible_move(color)
    pieces_possible_move = []

    (0..7).each do |i|
      @board.row(i).each do |s|
        next if s.empty? || s.color != color

        pieces_possible_move << {
          piece: s,
          possible_move: s.possible_move(@board)
        }
      end
    end

    pieces_possible_move
  end
end
