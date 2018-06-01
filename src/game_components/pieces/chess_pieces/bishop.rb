require_relative '../basic_piece'

# class of a Rook
class Bishop < BasicPiece
  def to_s
    @color == 'white' ? '♗' : '♝'
  end

  # @returns the list of position where the queen can move
  def get_possible_moves(board)
    
  end
end
