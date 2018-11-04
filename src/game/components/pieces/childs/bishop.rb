require_relative '../basic_piece'

class Bishop < BasicPiece
  def to_s
    @color == :w ? '♗' : '♝'
  end

  # position list of the controlled square
  # digonal + anti_diagonal
  def controlled_square(board)
    get_grouped_sides_of(board, :diagonal, :anti_diagonal)
      .flat_map { |side| filter_accessibility(side) }
      .map(&:position)
  end
end
