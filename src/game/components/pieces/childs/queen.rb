require_relative '../basic_piece'
require_relative '../../../../helper'

# class of a Rook
class Queen < BasicPiece
  def to_s
    @color == :w ? '♕' : '♛'
  end

  # position list of the controlled square
  # horizontal + vertical + diagonal + anti_diagonal
  def controlled_square(board)
    grouped_sides(
      board, :horizontal, :vertical, :diagonal, :anti_diagonal
    )
      .flat_map { |side| filter_accessibility(side) }
      .map(&:position)
  end
end
