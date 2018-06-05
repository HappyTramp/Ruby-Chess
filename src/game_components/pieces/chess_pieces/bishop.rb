require_relative '../basic_piece'

# class of a Rook
class Bishop < BasicPiece
  def to_s
    @color == 'white' ? '♗' : '♝'
  end

  # @returns the list of position where the queen can move
  def get_possible_moves(board)
    get_grouped_sides_of(board, 'diagonal', 'anti_diagonal')
      .map { |side| filter_side(side) }
      .flatten
      .map(&:position)
  end
end
