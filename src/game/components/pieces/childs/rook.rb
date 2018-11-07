require_relative '../basic_piece'
require_relative '../../../../helper'

# class of a Rook
class Rook < BasicPiece
  def to_s
    @color == :w ? '♖' : '♜'
  end

  # position list of the controlled square
  # horizontal + vertical
  def controlled_square(board)
    grouped_sides(board, :horizontal, :vertical)
      .flat_map { |side| filter_accessibility(side) }
      .map(&:position)
  end
end
