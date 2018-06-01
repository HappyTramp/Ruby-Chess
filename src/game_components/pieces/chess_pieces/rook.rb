require_relative '../basic_piece'


# class of a Rook
class Rook < BasicPiece
  def to_s
    @color == 'white' ? '♖' : '♜'
  end

  # @returns the list of position where the rook can move
  def possibilitiesList(board)
    left_side, right_side = horizontalCellsFromPosition(board)
    up_side, bellow_side = verticalCellsFromPosition(board)

    [
      *filterSide(left_side),
      *filterSide(right_side),
      *filterSide(up_side),
      *filterSide(bellow_side)
    ].map do |cell|
      cell.position
    end
  end
end
