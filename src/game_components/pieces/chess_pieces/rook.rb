require_relative '../basic_piece'

# class of a Rook
class Rook < BasicPiece
  def to_s
    @color == 'white' ? '♖' : '♜'
  end

  def possibilitiesList(board)
    left_side, right_side = horizontalCellsFromPosition(board)

    filterSide!(left_side)
    filterSide!(right_side)

    [*left_side, *right_side]
  end
end
