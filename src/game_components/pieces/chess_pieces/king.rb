require_relative '../basic_piece'

# class of a Rook
class King < BasicPiece
  def to_s
    @color == 'white' ? '♔' : '♚'
  end
end
