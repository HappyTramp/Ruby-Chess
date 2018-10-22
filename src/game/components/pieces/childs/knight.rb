require_relative '../basic_piece'

# class of a Rook
class Knight < BasicPiece
  def to_s
    @color == :w ? '♘' : '♞'
  end

  def controlled_squares(board)
    ([-1, 1].product([-2, 2]) + [-2, 2].product([-1, 1]))
      .map { |mod| [@position[0] + mod[0], @position[1] + mod[1]] }
      .select { |i| index_in_border?(*i) }
  end
end
