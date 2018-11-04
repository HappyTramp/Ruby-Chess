require_relative '../basic_piece'
require_relative '../../../../helpers'

# class of a Rook
class Pawn < BasicPiece
  def to_s
    @color == :w ? '♙' : '♟'
  end
  
  # remove ally and empty square from controlled square, add the forward move
  def possible_move(board)
    p_move = controlled_square(board).select { |p| square_type(board[*p]) == :enemy }

    first_rank = @color == :b ? 1 : 6
    x_mod = @color == :b ? 1 : -1

    destination = board[@position[0] + x_mod, @position[1]]
    p_move.push(destination.position) if square_type(destination) == :empty

    if @position[0] == first_rank
      destination = board[@position[0] + 2 * x_mod, @position[1]]
      p_move.push(destination.position) if square_type(destination) == :empty
    end

    p_move
  end

  # position list of the controlled square
  # the attacked one: +1 in diagonal
  def controlled_square(board)
    controlled = []
    x_mod = @color == :b ? 1 : -1
    left = [@position[0] + x_mod, @position[1] - 1]
    right = [@position[0] + x_mod, @position[1] + 1]
    controlled.push(left) if index_in_border?(*left)
    controlled.push(right) if index_in_border?(*right)
    controlled
  end
end
