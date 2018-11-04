require_relative '../basic_piece'
require_relative '../../../../helpers.rb'

# class of a Rook
class King < BasicPiece
  def to_s
    @color == :w ? '♔' : '♚'
  end

<<<<<<< HEAD
  def controlled_square(board)
=======
  def controlled_squares(board)
>>>>>>> pieces_controlled_square
    ([-1, 1, 0].product([-1, 1, 0]) - [[0, 0]])
      .map { |mod| [@position[0] + mod[0], @position[1] + mod[1]] }
      .select { |i| index_in_border?(*i) }
  end
end
