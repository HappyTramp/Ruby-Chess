require_relative '../basic_piece'

# class of a Rook
class Knight < BasicPiece
  def to_s
    @color == :w ? '♘' : '♞'
  end

  def get_possible_moves(board)
    ([-1, 1].product([-2, 2]) + [-2, 2].product([-1, 1]))
      .map { |mod| [@position[0] + mod[0], @position[1] + mod[1]] }
      .select { |pos| valid_cell?(board[*pos]) }
  end
end
