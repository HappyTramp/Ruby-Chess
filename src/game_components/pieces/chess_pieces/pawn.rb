require_relative '../basic_piece'

# class of a Rook
class Pawn < BasicPiece
  def to_s
    @color == 'white' ? '♙' : '♟'
  end
end
