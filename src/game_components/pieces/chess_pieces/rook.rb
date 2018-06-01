require_relative '../basic_piece'

# class of a Rook
class Rook < BasicPiece
  def to_s
    @color == 'white' ? '♖' : '♜'
  end

  # @returns the list of position where the rook can move
  def get_possible_moves(board)
    left_side, right_side = horizontal_cells_from_position(board)
    up_side, bellow_side = vertical_cells_from_position(board)

    [
      *filter_side(left_side),
      *filter_side(right_side),
      *filter_side(up_side),
      *filter_side(bellow_side)
    ].map(&:position)
  end
end
