require_relative '../basic_piece'


# class of a Rook
class Rook < BasicPiece
  def to_s
    @color == 'white' ? '♖' : '♜'
  end

  def possibilitiesList(board)
    left_side, right_side = horizontalCellsFromPosition(board)
    up_side, bellow_side = verticalCellsFromPosition(board)

    left_side = filterSide(left_side)
    right_side = filterSide(right_side)
    up_side = filterSide(up_side)
    bellow_side = filterSide(bellow_side)


    [*left_side, *right_side, *up_side, *bellow_side]
    .map do |cell|
      cell.position
    end
  end
end
