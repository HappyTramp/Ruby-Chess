require_relative '../basic_piece'

# class of a Rook
class Queen < BasicPiece
  def to_s
    @color == :w ? '♕' : '♛'
  end

  # @returns the list of position where the queen can move
  def controlled_squares(board)
    get_grouped_sides_of(
      board, :horizontal, :vertical, :diagonal, :anti_diagonal
    )
      .flat_map { |side| filter_accessibility(side) }
      .map(&:position)
  end
end
