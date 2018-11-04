require_relative '../basic_piece'

# class of a Rook
class Bishop < BasicPiece
  def to_s
    @color == :w ? '♗' : '♝'
  end

  # @returns the list of position where the queen can move
  def controlled_square(board)
    get_grouped_sides_of(board, :diagonal, :anti_diagonal)
      .flat_map { |side| filter_side(side) }
      .map(&:position)
  end
end
