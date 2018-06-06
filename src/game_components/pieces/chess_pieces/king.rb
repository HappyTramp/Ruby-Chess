require_relative '../basic_piece'

# class of a Rook
class King < BasicPiece
  def initialize(position, color)
    super(position, color)
    @first_move = true
  end

  def to_s
    @color == 'white' ? '♔' : '♚'
  end

  def get_possible_moves(board)

  end
end
