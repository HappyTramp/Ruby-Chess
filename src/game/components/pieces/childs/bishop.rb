require_relative '../../../../helper'
require_relative '../basic_piece'

# class of a bishop
class Bishop < BasicPiece
  def to_s
    @color == :w ? '♗' : '♝'
  end

  # position list of the controlled square
  # digonal + anti_diagonal
  def controlled_square(board)
    grouped_sides(board, :diagonal, :anti_diagonal)
      .flat_map { |side| filter_accessibility(side) }
      .map(&:position)
  end
end
