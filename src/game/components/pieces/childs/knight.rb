require_relative '../basic_piece'
require_relative '../../../../helper'

# class of a Rook
class Knight < BasicPiece
  def to_s
    @color == :w ? '♘' : '♞'
  end

  def type
    :N
  end

  # position list of the controlled square
  # move in 'L' shape: (+/-2, +/-1) and (+/-1, +/-2)
  def controlled_square(_)
    ([-1, 1].product([-2, 2]) + [-2, 2].product([-1, 1]))
      .map { |mod| [@position[0] + mod[0], @position[1] + mod[1]] }
      .select { |i| Helper::in_border?(*i) }
  end
end
